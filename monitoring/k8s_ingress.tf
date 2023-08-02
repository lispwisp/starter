resource "kubernetes_ingress_v1" "vmselect" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmselect"
    namespace = "monitoring"
    labels = {
      app = "vmselect"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "haproxy"
      "cert-manager.io/cluster-issuer" = "selfsigned"
      "haproxy.org/ssl" = "true"
    }
  }
  spec {
    tls {
      secret_name = "vmselect-tls"
      hosts = ["vmselect.dev.snifflewafflefizzlefaffle.com"]
    }
    ingress_class_name = "haproxy"
    rule {
      host = "vmselect.dev.snifflewafflefizzlefaffle.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "vmselect"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "grafana" {
  depends_on = [
    kubernetes_namespace_v1.monitoring,
    kubernetes_service_v1.grafana
  ]
  metadata {
    name = "grafana"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "haproxy"
      "cert-manager.io/cluster-issuer" = "selfsigned"
      "haproxy.org/ssl" = "true"
    }
  }
  spec {
    tls {
      secret_name = "grafana-tls"
      hosts = ["grafana.dev.snifflewafflefizzlefaffle.com"]
    }
    ingress_class_name = "haproxy"
    rule {
      host = "grafana.dev.snifflewafflefizzlefaffle.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}