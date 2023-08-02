resource "kubernetes_deployment_v1" "kube-state-metrics" {
  depends_on = [
    kubernetes_namespace_v1.kube-state-metrics
  ]
  metadata {
    name = "kube-state-metrics"
    namespace = "kube-system"
    labels = {
      app = "kube-state-metrics"
      "kube-monkey/enabled": "enabled",
      "kube-monkey/identifier": "kube-state-metrics",
      "kube-monkey/mtbf": "1",
      "kube-monkey/kill-mode": "fixed"
      "kube-monkey/kill-value": "1"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "kube-state-metrics"
      }
    }
    template {
      metadata {
        labels = {
          app = "kube-state-metrics"
          "kube-monkey/enabled": "enabled",
          "kube-monkey/identifier": "kube-state-metrics",
          "kube-monkey/mtbf": "1",
          "kube-monkey/kill-mode": "fixed"
          "kube-monkey/kill-value": "1"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port" = "8081"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key = "app"
                  operator = "In"
                  values = ["kube-state-metrics"]
                }
              }
            }
          }
        }
        automount_service_account_token = true
        termination_grace_period_seconds = 30
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        service_account_name = "kube-state-metrics"
        container {
          image = "bitnami/kube-state-metrics:latest"
          name  = "kube-state-metrics"
          image_pull_policy = "IfNotPresent"
          security_context {
            run_as_user = "65534"
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
          }

          port {
            name = "http-metrics"
            container_port = 8080
          }
          port {
            name = "telemetry"
            container_port = 8081
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "8081"
            }
            initial_delay_seconds = 5
            timeout_seconds = 5
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }
            initial_delay_seconds = 5
            timeout_seconds = 5
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
        }
      }
    }
  }
}