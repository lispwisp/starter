resource "kubernetes_service_v1" "cert-manager" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager,
  ]
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
  spec {
    type = "ClusterIP"
    port {
      protocol = "TCP"
      port = 9402
      name = "tcp-prometheus-servicemonitor"
      target_port = "9402"
    }
    selector = {
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "controller"
    }
  }
}

resource "kubernetes_service_v1" "cert-manager-webhook" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager,
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
  spec {
    type = "ClusterIP"
    port {
      protocol = "TCP"
      port = 443
      name = "https"
      target_port = "https"
    }
    selector = {
      "app.kubernetes.io/name" = "webhook"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "webhook"
    }
  }
}