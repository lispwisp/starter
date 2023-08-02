resource "kubernetes_namespace_v1" "node-exporter" {
  metadata {
    name = "node-exporter"
  }
}