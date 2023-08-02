resource "kubernetes_ingress_v1" "cockroachdb" {
  depends_on = [
    kubernetes_namespace_v1.cockroachdb
  ]
  metadata {
    name = "cockroachdb"
    namespace = "cockroachdb"
    labels = {
      "app.kubernetes.io/name" = "cockroachdb"
      "app.kubernetes.io/part-of" = "cockroachdb"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "haproxy"
      "cert-manager.io/cluster-issuer" = "selfsigned"
      "haproxy.org/ssl" = "true"
    }
  }
  spec {
    tls {
      secret_name = "cockroachdb-tls"
      hosts = ["cockroachdb.dev.snifflewafflefizzlefaffle.com"]
    }
    ingress_class_name = "haproxy"
    rule {
      host = "cockroachdb.dev.snifflewafflefizzlefaffle.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "cockroachdb"
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