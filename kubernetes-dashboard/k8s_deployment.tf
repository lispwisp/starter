resource "kubernetes_deployment_v1" "kubernetes-dashboard-api" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard-api"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/name" = "kubernetes-dashboard-api"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      "app.kubernetes.io/component" = "api"
      "app.kubernetes.io/version" = "v1.0.0"
    }
  }
  spec {
    replicas = 1
    revision_history_limit = 10
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kubernetes-dashboard-api"
        "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "kubernetes-dashboard-api"
          "app.kubernetes.io/part-of" = "kubernetes-dashboard"
          "app.kubernetes.io/component" = "api"
          "app.kubernetes.io/version" = "v1.0.0"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key = "app.kubernetes.io/name"
                  operator = "In"
                  values = ["kubernetes-dashboard-api"]
                }
              }
            }
          }
        }
        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "kubernetes-dashboard-api"
          image = "docker.io/kubernetesui/dashboard-api:v1.0.0"
          image_pull_policy = "IfNotPresent"
          port {
            name = "api"
            protocol = "TCP"
            container_port = 9000
          }
          args = [
            "--enable-insecure-login",
            "--namespace=kubernetes-dashboard"
          ]
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem = true
            run_as_user = "1001"
            run_as_group = "2001"
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
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
        service_account_name = "kubernetes-dashboard"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "kubernetes-dashboard-web" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard-web"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/name" = "kubernetes-dashboard-web"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      "app.kubernetes.io/component" = "web"
      "app.kubernetes.io/version" = "v1.0.0"
    }
  }
  spec {
    replicas = 1
    revision_history_limit = 10
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kubernetes-dashboard-web"
        "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "kubernetes-dashboard-web"
          "app.kubernetes.io/part-of" = "kubernetes-dashboard"
          "app.kubernetes.io/component" = "web"
          "app.kubernetes.io/version" = "v1.0.0"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key = "app.kubernetes.io/name"
                  operator = "In"
                  values = ["kubernetes-dashboard-web"]
                }
              }
            }
          }
        }
        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "kubernetes-dashboard-web"
          image = "docker.io/kubernetesui/dashboard-web:v1.0.0"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 8000
            name = "web"
            protocol = "TCP"
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem = true
            run_as_user = "1001"
            run_as_group = "2001"
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
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
        service_account_name = "kubernetes-dashboard"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "kubernetes-dashboard-metrics-scraper" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard-metrics-scraper"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/name" = "kubernetes-dashboard-metrics-scraper"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      "app.kubernetes.io/component" = "metrics"
      "app.kubernetes.io/version" = "v1.0.9"
    }
  }
  spec {
    replicas = 1
    revision_history_limit = 10
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kubernetes-dashboard-metrics-scraper"
        "app.kubernetes.io/part-of" = "kubernetes-dashboard"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "kubernetes-dashboard-metrics-scraper"
          "app.kubernetes.io/part-of" = "kubernetes-dashboard"
          "app.kubernetes.io/component" = "metrics"
          "app.kubernetes.io/version" = "v1.0.9"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key = "app.kubernetes.io/name"
                  operator = "In"
                  values = ["kubernetes-dashboard-metrics-scraper"]
                }
              }
            }
          }
        }
        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "kubernetes-dashboard-metrics-scraper"
          image = "docker.io/kubernetesui/metrics-scraper:v1.0.9"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 8000
            protocol = "TCP"
          }
          liveness_probe {
            http_get {
              scheme = "HTTP"
              path = "/"
              port = 8000
            }
            initial_delay_seconds = 30
            timeout_seconds = 30
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem = true
            run_as_user = "1001"
            run_as_group = "2001"
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
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
        service_account_name = "kubernetes-dashboard"
      }
    }
  }
}