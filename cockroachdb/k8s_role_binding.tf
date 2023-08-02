resource "kubernetes_role_binding_v1" "cockroachdb" {
  depends_on = [
    kubernetes_namespace_v1.cockroachdb
  ]
  metadata {
    name = "cockroachdb"
    namespace = "cockroachdb"
    labels = {
      app = "cockroachdb"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cockroachdb"
  }
  subject {
    kind = "ServiceAccount"
    name = "cockroachdb"
    namespace = "cockroachdb"
  }
}