resource "kubernetes_service_account_v1" "haproxy" {
  depends_on = [
    kubernetes_namespace_v1.haproxy
  ]
  metadata {
    name = "haproxy"
    namespace = "haproxy"
  }
}