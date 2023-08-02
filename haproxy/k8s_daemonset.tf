resource "kubernetes_daemon_set_v1" "haproxy" {
  depends_on = [
    kubernetes_namespace_v1.haproxy,
    kubernetes_config_map_v1.haproxy
  ]
  metadata {
    labels = {
      app = "haproxy"
    }
    name = "haproxy"
    namespace = "haproxy"
  }
  spec {
    selector {
      match_labels = {
        app = "haproxy"
      }
    }
    min_ready_seconds = 0
    template {
      metadata {
        labels = {
          app = "haproxy"
        }
        annotations = {
          "prometheus.io/scrape" = "true",
          "prometheus.io/port" = "6060"
        }
      }
      spec {
        enable_service_links = true
        service_account_name = "haproxy"
        termination_grace_period_seconds = 60
        dns_policy = "ClusterFirst"
        security_context {
          run_as_non_root = true
          run_as_user = "1000"
          run_as_group = "1000"
        }
        volume {
          name = "haproxy"
          config_map {
            name = "haproxy"
          }
        }
        container {
          name = "haproxy"
          image = "haproxytech/kubernetes-ingress:latest"
          args = [
            "--pprof",
            "--prometheus",
            "--configmap=haproxy/haproxy",
#            "--http-bind-port=80",
            "--https-bind-port=443",
            "--ingress.class=haproxy",
            "--log=info"
          ]
          security_context {
            run_as_non_root = true
            run_as_user = "1000"
            run_as_group = "1000"
            allow_privilege_escalation = true
            capabilities {
              drop = ["ALL"]
              add = ["NET_BIND_SERVICE"]
            }
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
#          port {
#            name = "http"
#            container_port = 80
#            protocol = "TCP"
#            host_port = 80
#          }
          port {
            name = "https"
            container_port = 443
            protocol = "TCP"
            host_port = 443
          }
          port {
            name = "prometheus"
            container_port = 1024
            protocol = "TCP"
            host_port = 1024
          }
          port {
            name = "healthz"
            container_port = 1042
            protocol = "TCP"
            host_port = 1042
          }
          port {
            name = "pprof"
            container_port = 6060
            protocol = "TCP"
            host_port = 6060
          }
          port {
            name = "default-backend"
            container_port = 6061
            protocol = "TCP"
            host_port = 6061
          }
          liveness_probe {
            failure_threshold = 3
            http_get {
              path = "/healthz"
              port = "1042"
              scheme = "HTTP"
            }
            initial_delay_seconds = 0
            period_seconds = 10
            success_threshold = 1
            timeout_seconds = 1
          }
          readiness_probe {
            failure_threshold = 3
            http_get {
              path = "/healthz"
              port = "1042"
              scheme = "HTTP"
            }
            initial_delay_seconds = 0
            period_seconds = 10
            success_threshold = 1
            timeout_seconds = 1
          }
          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
      }
    }
  }
}