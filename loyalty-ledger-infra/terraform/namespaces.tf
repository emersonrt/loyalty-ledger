# Namespaces and Secrets live in Terraform: Argo CD syncs the rest from Git,
# and no password has to be versioned.
resource "kubernetes_namespace_v1" "this" {
  for_each = toset(["platform", "loyalty"])

  metadata {
    name = each.key
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "random_password" "this" {
  for_each = toset(["postgres", "ledger_owner", "ledger_app", "debezium", "redis"])

  length  = 32
  special = false
}

locals {
  secrets = {
    "platform/postgres-credentials" = {
      POSTGRES_PASSWORD     = random_password.this["postgres"].result
      LEDGER_OWNER_PASSWORD = random_password.this["ledger_owner"].result
      LEDGER_APP_PASSWORD   = random_password.this["ledger_app"].result
      DEBEZIUM_PASSWORD     = random_password.this["debezium"].result
    }
    "platform/redis-credentials" = {
      REDIS_PASSWORD = random_password.this["redis"].result
    }
    "platform/kafka-connect-credentials" = {
      DEBEZIUM_DB_PASSWORD = random_password.this["debezium"].result
    }
    "loyalty/ledger-db" = {
      LEDGER_OWNER_PASSWORD = random_password.this["ledger_owner"].result
      LEDGER_APP_PASSWORD   = random_password.this["ledger_app"].result
    }
    "loyalty/ledger-redis" = {
      REDIS_PASSWORD = random_password.this["redis"].result
    }
  }
}

resource "kubernetes_secret_v1" "this" {
  for_each = local.secrets

  metadata {
    namespace = kubernetes_namespace_v1.this[split("/", each.key)[0]].metadata[0].name
    name      = split("/", each.key)[1]
  }

  data = each.value
}
