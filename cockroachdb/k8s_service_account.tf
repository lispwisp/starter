resource "kubernetes_service_account_v1" "cockroachdb" {
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
}