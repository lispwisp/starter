resource "kubernetes_service_v1" "cockroachdb" {
  depends_on = [
    kubernetes_namespace_v1.cockroachdb
  ]
  metadata {
    name = "cockroachdb"
    namespace = "cockroachdb"
    labels = {
      app = "cockroachdb"
    }
    annotations = {
      "purelb.io/service-group": "default"
    }
  }
  spec {
    port {
      port = 26257
      target_port = 26257
      name = "sql"
    }
    port {
      port = 8080
      target_port = 8080
      name = "http"
    }
    selector = {
      app = "cockroachdb"
    }
  }
}

resource "kubernetes_service_v1" "cockroachdb-internal" {
  depends_on = [
    kubernetes_namespace_v1.cockroachdb
  ]
  metadata {
    name = "cockroachdb-internal"
    namespace = "cockroachdb"
    labels = {
      app = "cockroachdb"
    }
    annotations = {
      "service.alpha.kubernetes.io/tolerate-unready-endpoints" = "true"
      "prometheus.io/scrape" = "true"
      "prometheus.io/path" = "_status/vars"
      "prometheus.io/port" = "8080"
      "purelb.io/service-group": "default"
    }
  }
  spec {
    port {
      port = 26258
      target_port = 26257
      name = "intranode"
    }
    port {
      port = 26257
      target_port = 26257
      name = "sql"
    }
    port {
      port = 8080
      target_port = 8080
      name = "http"
    }
    publish_not_ready_addresses = true
    cluster_ip = "None"
    selector = {
      app = "cockroachdb"
    }
  }
}