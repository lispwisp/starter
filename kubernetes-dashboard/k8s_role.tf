resource "kubernetes_role_v1" "kubernetes-dashboard" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    resource_names = ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-csrf"]
    verbs = ["get", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["kubernetes-dashboard-settings"]
    verbs = ["get", "update"]
  }
  rule {
    api_groups = [""]
    resources = ["services/proxy"]
    resource_names = [ "kubernetes-dashboard-metrics-scraper", "http:kubernetes-dashboard-metrics-scraper" ]
    verbs = ["get"]
  }
}