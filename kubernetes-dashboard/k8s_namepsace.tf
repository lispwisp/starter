resource "kubernetes_namespace_v1" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
}