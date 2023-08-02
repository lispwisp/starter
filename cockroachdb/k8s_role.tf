resource "kubernetes_role_v1" "cockroachdb" {
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
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get"]
  }
}