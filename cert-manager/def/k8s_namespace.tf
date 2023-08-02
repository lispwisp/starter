resource "kubernetes_namespace_v1" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}