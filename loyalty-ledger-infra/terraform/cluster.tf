resource "kind_cluster" "this" {
  name            = var.cluster_name
  node_image      = var.node_image
  wait_for_ready  = true
  kubeconfig_path = local.kubeconfig_path

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # The only port the cluster exposes, on loopback only. All traffic enters through Traefik.
      extra_port_mappings {
        container_port = local.traefik_web_node_port
        host_port      = var.http_port
        listen_address = "127.0.0.1"
        protocol       = "TCP"
      }
    }
  }
}

locals {
  kubeconfig_path       = pathexpand("~/.kube/kind-${var.cluster_name}")
  traefik_web_node_port = 30080
}
