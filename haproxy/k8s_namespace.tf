resource "kubernetes_namespace_v1" "haproxy" {
  metadata {
    name = "haproxy"
  }
}