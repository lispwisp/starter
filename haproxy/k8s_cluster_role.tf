resource "kubernetes_cluster_role_v1" "haproxy" {
  metadata {
    name = "haproxy"
  }
  rule {
    api_groups = [""]
    resources = ["configmaps", "endpoints", "nodes", "pods", "services", "namespaces", "events", "serviceaccounts"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses", "ingresses/status", "ingressclasses"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses/status"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch", "create", "patch", "update"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources = ["endpointslices"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["core.haproxy.org"]
    resources = ["*"]
    verbs = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources = ["customresourcedefinitions"]
    verbs = ["get", "list", "watch", "update"]
  }
}