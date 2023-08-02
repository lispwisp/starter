resource "kubernetes_namespace_v1" "cockroachdb" {
  metadata {
    name = "cockroachdb"
  }
}