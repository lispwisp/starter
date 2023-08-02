resource "kubernetes_stateful_set_v1" "vmselect" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmselect"
    namespace = "monitoring"
    labels = {
      app = "vmselect"
    }
  }
  spec {
    service_name = "vmselect"
    selector {
      match_labels = {
        app = "vmselect"
      }
    }
    replicas = 3
    template {
      metadata {
        labels = {
          app = "vmselect"
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
                  values = ["vmselect"]
                }
              }
            }
          }
        }
        container {
          name = "vmselect"
          image = "victoriametrics/vmselect:v1.92.0-cluster"
          image_pull_policy = "IfNotPresent"
          args = [
            "--cacheDataPath=/cache",
            "--storageNode=vmstorage-0.vmstorage.monitoring.svc.cluster.local:8401",
            "--storageNode=vmstorage-1.vmstorage.monitoring.svc.cluster.local:8401",
            "--storageNode=vmstorage-2.vmstorage.monitoring.svc.cluster.local:8401",
            "--selectNode=vmselect-0.vmselect.monitoring.svc.cluster.local:8481",
            "--selectNode=vmselect-1.vmselect.monitoring.svc.cluster.local:8481",
            "--selectNode=vmselect-2.vmselect.monitoring.svc.cluster.local:8481",
            "--envflag.enable=true",
            "--envflag.prefix=VM_",
            "--loggerFormat=json"
          ]
          port {
            name = "http"
            container_port = 8481
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds = 15
          }
          liveness_probe {
            tcp_socket {
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds = 15
            timeout_seconds = 5
          }
          volume_mount {
            mount_path = "/cache"
            name       = "cache-volume"
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "cache-volume"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            "storage" = "2Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set_v1" "vmstorage" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmstorage"
    namespace = "monitoring"
    labels = {
      app = "vmstorage"
    }
  }
  spec {
    service_name = "vmstorage"
    selector {
      match_labels = {
        app = "vmstorage"
      }
    }
    replicas = 3
    template {
      metadata {
        labels = {
          app = "vmstorage"
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
                  values = ["vmstorage"]
                }
              }
            }
          }
        }
        automount_service_account_token = true
        container {
          name = "vmstorage"
          image = "victoriametrics/vmstorage:v1.92.0-cluster"
          image_pull_policy = "IfNotPresent"
          args = [
            "--retentionPeriod=1",
            "--storageDataPath=/storage",
            "--envflag.enable=true",
            "--envflag.prefix=VM_",
            "--loggerFormat=json"
          ]
          port {
            name = "http"
            container_port = 8482
          }
          port {
            name = "vminsert"
            container_port = 8400
          }
          port {
            name = "vmselect"
            container_port = 8401
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            failure_threshold = 3
            initial_delay_seconds = 5
            period_seconds = 15
            timeout_seconds = 5
          }
          liveness_probe {
            tcp_socket {
              port = "http"
            }
            failure_threshold = 10
            initial_delay_seconds = 30
            period_seconds = 30
            timeout_seconds = 5
          }
          volume_mount {
            mount_path = "/storage"
            name       = "vmstorage-volume"
          }
        }
        service_account_name = "victoria-metrics"
        termination_grace_period_seconds = 60
      }
    }
    volume_claim_template {
      metadata {
        name = "vmstorage-volume"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            "storage" = "8Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set_v1" "vmagent" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmagent"
    namespace = "monitoring"
    labels = {
      app = "vmagent"
    }
  }
  spec {
    service_name = "vmagent"
    selector {
      match_labels = {
        app = "vmagent"
      }
    }
    replicas = 3
    template {
      metadata {
        labels = {
          app = "vmagent"
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
                  values = ["vmagent"]
                }
              }
            }
          }
        }
        service_account_name = "vmagent"
        container {
          name = "vmagent"
          image = "victoriametrics/vmagent:v1.92.1"
          image_pull_policy = "IfNotPresent"
          args = [
            "-promscrape.config=/config/scrape.yml",
            "-remoteWrite.tmpDataPath=/tmpData",
            "-remoteWrite.url=http://vminsert.monitoring.svc.cluster.local:8480/insert/0/prometheus",
            "-envflag.enable=true",
            "-envflag.prefix=VM_",
            "-loggerFormat=json"
          ]
          port {
            name = "http"
            container_port = 8429
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds = 15
          }
          liveness_probe {
            tcp_socket {
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds = 15
            timeout_seconds = 5
          }
          volume_mount {
            mount_path = "/tmpData"
            name       = "tmpdata"
          }
          volume_mount {
            mount_path = "/config"
            name       = "config"
          }
        }
        volume {
          name = "config"
          config_map {
            name = "vmagent"
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "tmpdata"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            "storage" = "10Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set_v1" "grafana" {
  depends_on = [
    kubernetes_namespace_v1.monitoring,
  ]
  metadata {
    name = "grafana"
    namespace = "monitoring"
    labels = {
      app = "grafana"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "grafana"
      }
    }
    replicas = 1
    service_name = "grafana"
    template {
      metadata {
        labels = {
          app = "grafana"
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
                  values = ["grafana"]
                }
              }
            }
          }
        }
        volume {
          name = "grafana-datasources"
          config_map {
            name = "grafana-datasources"
          }
        }
        container {
          name = "grafana"
          image = "bitnami/grafana:latest"
          port {
            container_port = 3000
            protocol = "TCP"
          }
          volume_mount {
            mount_path = "/opt/bitnami/grafana/conf/provisioning/datasources"
            name       = "grafana-datasources"
          }
          volume_mount {
            mount_path = "/opt/bitnami/grafana/data"
            name       = "persistence"
          }
          #          env {
          #            name = "GF_SECURITY_ADMIN_USER"
          #            value_from {
          #              secret_key_ref {
          #                name = "gf-security"
          #                key = "admin-user"
          #              }
          #            }
          #          }
          #          env {
          #            name = "GF_SECURITY_ADMIN_PASSWORD"
          #            value_from {
          #              secret_key_ref {
          #                name = "gf-security"
          #                key = "admin-password"
          #              }
          #            }
          #          }
          #          env {
          #            name = "GF_DS_PROM_PASS"
          #            value_from {
          #              secret_key_ref {
          #                name = "gf-ds"
          #                key = "prom-password"
          #              }
          #            }
          #          }
          resources {
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "persistence"
        namespace = "monitoring"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "256Mi"
          }
        }
      }
    }
  }
}