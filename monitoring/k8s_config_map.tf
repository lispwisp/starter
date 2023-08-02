resource "kubernetes_config_map_v1" "vmagent" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmagent"
    namespace = "monitoring"
  }
  data = {
    "scrape.yml" = file("${path.module}/scrape.yml")
  }
}

resource "kubernetes_config_map_v1" "grafana-datasources" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "grafana-datasources"
    namespace = "monitoring"
  }
  data = {
    "datasources.yaml" = file("${path.module}/datasources.yaml")
  }
}