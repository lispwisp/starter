resource "kubernetes_cluster_role_binding_v1" "haproxy" {
  metadata {
    name = "haproxy"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "haproxy"
  }
  subject {
    kind = "ServiceAccount"
    name = "haproxy"
    namespace = "haproxy"
  }
}