locals {
  argocd_host = "argocd.localhost"
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_versions.argocd
  wait             = true

  values = [yamlencode({
    global = {
      domain = local.argocd_host
    }
    configs = {
      params = {
        # TLS terminates at Traefik; argocd-server speaks HTTP inside the cluster.
        "server.insecure" = true
      }
    }
    server = {
      ingress = {
        enabled          = true
        ingressClassName = "traefik"
      }
    }
    dex = {
      enabled = false
    }
  })]

  depends_on = [helm_release.traefik]
}

# Applications via chart: avoids kubernetes_manifest, which requires the Argo CRDs at plan time.
resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  namespace  = helm_release.argocd.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.chart_versions.argocd_apps

  values = [yamlencode({
    applications = {
      for name, app in local.argocd_applications : name => {
        namespace  = helm_release.argocd.namespace
        project    = "default"
        finalizers = ["resources-finalizer.argocd.argoproj.io"]
        source = {
          repoURL        = var.git_repo_url
          targetRevision = var.git_revision
          path           = app.path
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = app.namespace
        }
        syncPolicy = {
          automated = {
            prune    = true
            selfHeal = true
          }
          retry = {
            limit = 10
            backoff = {
              duration    = "10s"
              factor      = 2
              maxDuration = "3m"
            }
          }
        }
      }
    }
  })]

  depends_on = [kubernetes_secret_v1.this]
}

locals {
  argocd_applications = {
    platform = {
      path      = "loyalty-ledger-infra/k8s/platform"
      namespace = kubernetes_namespace_v1.this["platform"].metadata[0].name
    }
    loyalty-ledger = {
      path      = "loyalty-ledger-infra/k8s/app"
      namespace = kubernetes_namespace_v1.this["loyalty"].metadata[0].name
    }
  }
}
