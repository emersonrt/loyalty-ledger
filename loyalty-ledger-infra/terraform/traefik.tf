locals {
  ip_allowlist_middleware = "ip-allowlist"
}

resource "helm_release" "traefik" {
  name             = "traefik"
  namespace        = "traefik"
  create_namespace = true
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.chart_versions.traefik
  wait             = true

  values = [yamlencode({
    ingressClass = {
      enabled        = true
      isDefaultClass = true
    }

    service = {
      spec = {
        type = "NodePort"
        # Preserves the source IP (no kube-proxy SNAT); otherwise the allowlist would see the node IP.
        externalTrafficPolicy = "Local"
      }
    }

    ports = {
      web = {
        nodePort = local.traefik_web_node_port
        # Does not trust client-sent X-Forwarded-For: the allowlist uses the real connection IP.
        forwardedHeaders = {
          insecure   = false
          trustedIPs = []
        }
        # Applied to every request at the entrypoint, before any routing.
        http = {
          middlewares = ["traefik-${local.ip_allowlist_middleware}@kubernetescrd"]
        }
      }
      websecure = {
        expose = { default = false }
      }
    }

    # The access log shows the source IP seen by Traefik, which helps tune the allowlist.
    accessLog = {
      enabled = true
    }

    extraObjects = [{
      apiVersion = "traefik.io/v1alpha1"
      kind       = "Middleware"
      metadata = {
        name      = local.ip_allowlist_middleware
        namespace = "traefik"
      }
      spec = {
        ipAllowList = {
          sourceRange = var.allowed_source_cidrs
        }
      }
    }]
  })]

  depends_on = [kind_cluster.this]
}
