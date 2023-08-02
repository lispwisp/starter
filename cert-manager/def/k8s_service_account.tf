resource "kubernetes_service_account_v1" "cert-manager-cainjector" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
  ]
  automount_service_account_token = true
  metadata {
    name = "cert-manager-cainjector"
    namespace = "cert-manager"
    labels = {
      app = "cainjector"
      "app.kubernetes.io/name" = "cainjector"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
}

resource "kubernetes_service_account_v1" "cert-manager" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
  ]
  automount_service_account_token = true
  metadata {
    name = "cert-manager"
    namespace = "cert-manager"
    labels = {
      app = "cert-manager"
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
}

resource "kubernetes_service_account_v1" "cert-manager-webhook" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
  ]
  automount_service_account_token = true
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