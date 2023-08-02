resource "kubernetes_stateful_set_v1" "cockroachdb" {
  depends_on = [
    kubernetes_namespace_v1.cockroachdb,
    kubernetes_role_v1.cockroachdb,
    kubernetes_role_binding_v1.cockroachdb,
    kubernetes_service_account_v1.cockroachdb,
    kubernetes_service_v1.cockroachdb-internal
  ]
  metadata {
    name = "cockroachdb"
    namespace = "cockroachdb"
    labels = {
      app = "cockroachdb"
      "kube-monkey/enabled": "enabled",
      "kube-monkey/identifier": "cockroachdb",
      "kube-monkey/mtbf": "1",
      "kube-monkey/kill-mode": "fixed"
      "kube-monkey/kill-value": "1"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "cockroachdb"
      }
    }
    replicas     = 3
    service_name = "cockroachdb-internal"
    pod_management_policy = "Parallel"
    template {
      metadata {
        labels = {
          app = "cockroachdb"
          "kube-monkey/enabled": "enabled",
          "kube-monkey/identifier": "cockroachdb",
          "kube-monkey/mtbf": "1",
          "kube-monkey/kill-mode": "fixed"
          "kube-monkey/kill-value": "1"
        }
      }
      spec {
        service_account_name = "cockroachdb"
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["cockroachdb"]
                }
              }
            }
          }
        }
        container {
          name  = "cockroachdb"
          image = "cockroachdb/cockroach:latest"
          port {
            container_port = 26258
            name = "intranode"
          }
          port {
            container_port = 26257
            name = "sql"
          }
          port {
            container_port = 8080
            name = "http"
          }
          readiness_probe {
            http_get {
              path = "/health?ready=1"
              port = "http"
#              scheme = "HTTPS"
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds = 5
            failure_threshold = 2
          }
          volume_mount {
            mount_path = "/cockroach/cockroach-data"
            name       = "datadir"
          }
#          volume_mount {
#            mount_path = "/cockroach/cockroach-certs"
#            name       = "certs"
#          }
          env {
            name = "COCKROACH_CHANNEL"
            value = "kubernetes-secure"
          }
          env {
            name = "GOMAXPROCS"
            value_from {
              resource_field_ref {
                resource = "limits.cpu"
              }
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
          command = [
            "/cockroach/cockroach",
            "start",
            "--attrs=ram:400mb",
            "--attrs=cpu:1",
            "--attrs=disk:ssd",
            "--logtostderr=INFO",
            "--no-color=true",
            "--insecure=true",
            "--listen-addr=:26258",
            "--sql-addr=:26257",
            "--advertise-addr=$(POD_NAME).cockroachdb-internal.cockroachdb.svc.cluster.local:26258",
            "--advertise-sql-addr=$(POD_NAME).cockroachdb-internal.cockroachdb.svc.cluster.local:26257",
#            "--certs-dir=/cockroach/cockroach-certs",
            "--join=cockroachdb-0.cockroachdb-internal.cockroachdb.svc.cluster.local:26258,cockroachdb-1.cockroachdb-internal.cockroachdb.svc.cluster.local:26258,cockroachdb-2.cockroachdb-internal.cockroachdb.svc.cluster.local:26258",
            "--cache=.25",
            "--max-sql-memory=.25",
          ]
          resources {
            limits = {
              cpu    = "400m"
              memory = "400Mi"
            }
            requests = {
              cpu    = "200m"
              memory = "200Mi"
            }
          }
        }
        termination_grace_period_seconds = 60
        volume {
          name = "datadir"
          persistent_volume_claim {
            claim_name = "datadir"
          }
        }
#        volume {
#          name = "certs"
#          secret {
#            secret_name = "cockroachdb.node"
#            default_mode = "256"
#          }
#        }
      }
    }
    volume_claim_template {
      metadata {
        name = "datadir"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "16Gi"
          }
        }
      }
    }
  }
}