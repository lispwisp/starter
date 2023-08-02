resource "kubernetes_cluster_role" "vmagent" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmagent"
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources = ["endpointslices"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    non_resource_urls = ["/metrics", "/metrics/cadvisor"]
    verbs = ["get"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch"]
  }
}