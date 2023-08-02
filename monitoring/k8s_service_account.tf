resource "kubernetes_service_account_v1" "victoria-metrics" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "victoria-metrics"
    namespace = "monitoring"
  }
}

resource "kubernetes_service_account_v1" "vmagent" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmagent"
    namespace = "monitoring"
  }
}