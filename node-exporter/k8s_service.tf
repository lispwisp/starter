resource "kubernetes_service_v1" "node-exporter" {
  depends_on = [
    kubernetes_namespace_v1.node-exporter
  ]
  metadata {
    name = "node-exporter"
    namespace = "node-exporter"
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port" = "9100"
      "purelb.io/service-group": "default"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/component" = "exporter"
      "app.kubernetes.io/name" = "node-exporter"
    }
    port {
      name = "node-exporter"
      protocol = "TCP"
      port = 9100
      target_port = 9100
    }
  }
}