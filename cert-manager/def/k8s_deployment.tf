resource "kubernetes_deployment_v1" "cert-manager-cainjector" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
  ]
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
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "cainjector"
        "app.kubernetes.io/instance" = "cert-manager"
        "app.kubernetes.io/component" = "cainjector"
      }
    }
    template {
      metadata {
        labels = {
          app = "cainjector"
          "app.kubernetes.io/name" = "cainjector"
          "app.kubernetes.io/instance" = "cert-manager"
          "app.kubernetes.io/component" = "cainjector"
          "app.kubernetes.io/version" = "v1.12.0"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["cainjector"]
                }
              }
            }
          }
        }
        service_account_name = "cert-manager-cainjector"
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "cert-manager-cainjector"
          image = "quay.io/jetstack/cert-manager-cainjector:v1.12.0"
          image_pull_policy = "IfNotPresent"
          args = ["--v=2", "--leader-election-namespace=kube-system"]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
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
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "cert-manager" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
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
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "cert-manager"
        "app.kubernetes.io/instance" = "cert-manager"
        "app.kubernetes.io/component" = "controller"
      }
    }
    template {
      metadata {
        labels = {
          app = "cert-manager"
          "app.kubernetes.io/name" = "cert-manager"
          "app.kubernetes.io/instance" = "cert-manager"
          "app.kubernetes.io/component" = "controller"
          "app.kubernetes.io/version" = "v1.12.0"
        }
        annotations = {
          "prometheus.io/path" = "/metrics"
          "prometheus.io/scrape" = "true"
          "prometheus.io/port" = "9402"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["cert-manager"]
                }
              }
            }
          }
        }
        service_account_name = "cert-manager"
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "cert-manager-controller"
          image = "quay.io/jetstack/cert-manager-controller:v1.12.0"
          image_pull_policy = "IfNotPresent"
          args = [
            "--v=2",
            "--cluster-resource-namespace=$(POD_NAMESPACE)",
            "--leader-election-namespace=kube-system",
            "--acme-http01-solver-image=quay.io/jetstack/cert-manager-acmesolver:v1.12.0",
            "--max-concurrent-challenges=60"
          ]
          port {
            container_port = 9402
            name = "http-metrics"
            protocol = "TCP"
          }
          port {
            container_port = 9403
            name = "http-healthz"
            protocol = "TCP"
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
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
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "cert-manager-webhook" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
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
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "webhook"
        "app.kubernetes.io/instance" = "cert-manager"
        "app.kubernetes.io/component" = "webhook"
      }
    }
    template {
      metadata {
        labels = {
          app = "webhook"
          "app.kubernetes.io/name" = "webhook"
          "app.kubernetes.io/instance" = "cert-manager"
          "app.kubernetes.io/component" = "webhook"
          "app.kubernetes.io/version" = "v1.12.0"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["webhook"]
                }
              }
            }
          }
        }
        service_account_name = "cert-manager-webhook"
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "cert-manager-webhook"
          image = "quay.io/jetstack/cert-manager-webhook:v1.12.0"
          image_pull_policy = "IfNotPresent"
          args = [
            "--v=2",
            "--secure-port=10250",
            "--dynamic-serving-ca-secret-namespace=$(POD_NAMESPACE)",
            "--dynamic-serving-ca-secret-name=cert-manager-webhook-ca",
            "--dynamic-serving-dns-names=cert-manager-webhook",
            "--dynamic-serving-dns-names=cert-manager-webhook.$(POD_NAMESPACE)",
            "--dynamic-serving-dns-names=cert-manager-webhook.$(POD_NAMESPACE).svc"
          ]
          port {
            name = "https"
            protocol = "TCP"
            container_port = 10250
          }
          port {
            name = "healthcheck"
            protocol = "TCP"
            container_port = 6080
          }
          liveness_probe {
            http_get {
              path = "/livez"
              port = 6080
              scheme = "HTTP"
            }
            initial_delay_seconds = 60
            period_seconds = 10
            timeout_seconds = 1
            success_threshold = 1
            failure_threshold = 3
          }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = 6080
              scheme = "HTTP"
            }
            initial_delay_seconds = 5
            period_seconds = 5
            timeout_seconds = 1
            success_threshold = 1
            failure_threshold = 3
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
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
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
      }
    }
  }
}