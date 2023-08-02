resource "kubernetes_service_account_v1" "kubernetes-dashboard" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
}