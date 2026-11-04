# The providers point at the cluster created in this same root module. Acceptable for a
# local environment; in the cloud, the cluster and its workloads would use separate states.
locals {
  cluster_auth = {
    host                   = kind_cluster.this.endpoint
    client_certificate     = kind_cluster.this.client_certificate
    client_key             = kind_cluster.this.client_key
    cluster_ca_certificate = kind_cluster.this.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = local.cluster_auth.host
  client_certificate     = local.cluster_auth.client_certificate
  client_key             = local.cluster_auth.client_key
  cluster_ca_certificate = local.cluster_auth.cluster_ca_certificate
}

provider "helm" {
  kubernetes = local.cluster_auth
}
