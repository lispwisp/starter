resource "kubernetes_pod_disruption_budget_v1" "kube-state-metrics" {
  depends_on = [
    kubernetes_namespace_v1.kube-state-metrics
  ]
  metadata {
    name = "kube-state-metrics"
    namespace = "kube-state-metrics"
    labels = {
      app = "kube-state-metrics"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "kube-state-metrics"
      }
    }
    max_unavailable = "1"
  }
}