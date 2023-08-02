resource "kubernetes_manifest" "selfsigned" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Issuer"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/name" = "certmanager"
        "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      }
      "name" = "selfsigned"
      "namespace" = "kubernetes-dashboard"
    }
    "spec" = {
      "selfSigned" = {}
    }
  }
}