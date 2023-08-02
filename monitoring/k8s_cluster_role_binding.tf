resource "kubernetes_cluster_role_binding_v1" "vmagent" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmagent"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "vmagent"
  }
  subject {
    kind = "ServiceAccount"
    name = "vmagent"
    namespace = "monitoring"
  }
}