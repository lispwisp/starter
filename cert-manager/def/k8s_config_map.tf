resource "kubernetes_config_map_v1" "cert-manager-webhook" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
  ]
  metadata {
    name = "cert-manager-webhook"
    namespace = "cert-manager"
    labels = {
      app = "webhook"
      "app.kubernetes.io/name" = "webhook"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
}