resource "kubernetes_service_v1" "kube-state-metrics" {
  depends_on = [
    kubernetes_namespace_v1.kube-state-metrics
  ]
  metadata {
    name = "kube-state-metrics"
    namespace = "kube-system"
    labels = {
      app = "kube-state-metrics"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port" = "8081"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
    type = "NodePort"
    port {
      name = "http-metrics"
      port = 8080
      target_port = "http-metrics"
    }
    port {
      name = "telemetry"
      port = 8081
      target_port = "telemetry"
    }
  }
}