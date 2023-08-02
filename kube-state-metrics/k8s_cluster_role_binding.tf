resource "kubernetes_cluster_role_binding_v1" "kube-state-metrics" {
  depends_on = [
    kubernetes_cluster_role_v1.kube-state-metrics
  ]
  metadata {
    name = "kube-state-metrics"
    labels = {
      "app.kubernetes.io/component" = "exporter"
      "app.kubernetes.io/name" = "kube-state-metrics"
      "app.kubernetes.io/version" = "2.8.0"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-state-metrics"
  }
  subject {
    kind = "ServiceAccount"
    name = "kube-state-metrics"
    namespace = "kube-system"
  }
}