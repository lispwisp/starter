resource "kubernetes_secret_v1" "kubernetes-dashboard-csrf" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard-csrf"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
  data = {
    csrf = ""
  }
}

resource "kubernetes_secret_v1" "kubernetes-dashboard-key-holder" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard-key-holder"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
}