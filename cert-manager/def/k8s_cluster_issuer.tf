resource "kubernetes_manifest" "selfsigned" {
  depends_on = [
    kubernetes_service_account_v1.cert-manager-webhook,
    kubernetes_service_v1.cert-manager-webhook,
  ]
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "ClusterIssuer"
    "metadata" = {
      "name" = "selfsigned"
    }
    "spec" = {
      "selfSigned" = {}
    }
  }
}
