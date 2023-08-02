resource "kubernetes_ingress_v1" "kubernetes-dashboard" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/name" = "kubernetes-dashboard"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "haproxy"
      "cert-manager.io/cluster-issuer" = "selfsigned"
      "haproxy.org/ssl" = "true"
    }
  }
  spec {
    tls {
      secret_name = "kubernetes-dashboard-tls"
      hosts = ["kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com"]
    }
    ingress_class_name = "haproxy"
    rule {
      host = "kubernetes-dashboard.dev.snifflewafflefizzlefaffle.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "kubernetes-dashboard-web"
              port {
                name = "web"
              }
            }
          }
        }
        path {
          path = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = "kubernetes-dashboard-api"
              port {
                name = "api"
              }
            }
          }
        }
      }
    }
  }
}