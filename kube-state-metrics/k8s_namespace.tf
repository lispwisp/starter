resource "kubernetes_namespace_v1" "kube-state-metrics" {
  metadata {
    name = "kube-state-metrics"
  }
}