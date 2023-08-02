resource "kubernetes_service_account_v1" "kube-state-metrics" {
  depends_on = [
    kubernetes_namespace_v1.kube-state-metrics
  ]
  metadata {
    name = "kube-state-metrics"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "exporter"
      "app.kubernetes.io/name" = "kube-state-metrics"
      "app.kubernetes.io/version" = "2.8.0"
    }
  }
}