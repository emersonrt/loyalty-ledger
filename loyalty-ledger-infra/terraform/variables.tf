variable "cluster_name" {
  description = "kind cluster name."
  type        = string
  default     = "loyalty-ledger"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,30}$", var.cluster_name))
    error_message = "Use lowercase letters, digits, and hyphens (2 to 31 characters)."
  }
}

variable "node_image" {
  description = "kind node image. Pinned by digest, compatible with the kind version embedded in the provider."
  type        = string
  default     = "kindest/node:v1.37.0@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5"
}

variable "http_port" {
  description = "Host port (127.0.0.1) that reaches the Traefik HTTP entrypoint."
  type        = number
  default     = 8080

  validation {
    condition     = var.http_port >= 1024 && var.http_port <= 65535
    error_message = "Use an unprivileged port (1024-65535)."
  }
}

variable "allowed_source_cidrs" {
  description = <<-EOT
    CIDRs allowed to reach any service exposed by Traefik. Other requests get a 403.
    On kind, the source IP seen by Traefik is the gateway of the "kind" docker network (e.g. 172.18.0.1),
    not 127.0.0.1. Check the real IP in the Traefik access logs.
  EOT
  type        = list(string)
  default     = ["172.16.0.0/12"]

  validation {
    condition     = length(var.allowed_source_cidrs) > 0 && alltrue([for c in var.allowed_source_cidrs : can(cidrhost(c, 0))])
    error_message = "Provide at least one valid CIDR (e.g. 172.18.0.1/32)."
  }
}

variable "git_repo_url" {
  description = "HTTPS URL of the Git repository tracked by Argo CD (must be reachable from the cluster)."
  type        = string

  validation {
    condition     = startswith(var.git_repo_url, "https://")
    error_message = "Use the HTTPS URL of the repository."
  }
}

variable "git_revision" {
  description = "Branch, tag, or commit synced by Argo CD."
  type        = string
  default     = "main"
}

variable "chart_versions" {
  description = "Pinned Helm chart versions."
  type = object({
    traefik     = string
    argocd      = string
    argocd_apps = string
  })
  default = {
    traefik     = "42.1.3"
    argocd      = "10.11.6"
    argocd_apps = "2.0.7"
  }
}
