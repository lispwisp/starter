resource "kubernetes_config_map_v1" "haproxy" {
  depends_on = [
    kubernetes_namespace_v1.haproxy
  ]
  metadata {
    name = "haproxy"
    namespace = "haproxy"
  }
  data = {
    "maxconn" = "1024"
    "syslog-server" = "address:stdout, format: raw, facility:local0"
  }
}