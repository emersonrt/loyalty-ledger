output "kubeconfig_path" {
  description = "Use with: export KUBECONFIG=<value>"
  value       = kind_cluster.this.kubeconfig_path
}

output "argocd_url" {
  value = "http://${local.argocd_host}:${var.http_port}"
}

output "app_url" {
  value = "http://ledger.localhost:${var.http_port}"
}

output "argocd_admin_password_command" {
  description = "Initial password of the Argo CD admin user."
  value       = "kubectl --kubeconfig ${kind_cluster.this.kubeconfig_path} -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "kind_node_container" {
  description = "Node container, used by the Makefile to load local images."
  value       = "${var.cluster_name}-control-plane"
}
