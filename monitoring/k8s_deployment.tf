resource "kubernetes_deployment_v1" "vminsert" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vminsert"
    namespace = "monitoring"
    labels = {
      app = "vminsert"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "vminsert"
      }
    }
    replicas = 3
    template {
      metadata {
        labels = {
          app = "vminsert"
        }
      }
      spec {
        automount_service_account_token = true
        container {
          name = "vminsert"
          image = "victoriametrics/vminsert:v1.92.0-cluster"
          image_pull_policy = "IfNotPresent"
          args = [
            "--storageNode=vmstorage-0.vmstorage.monitoring.svc.cluster.local:8400",
            "--storageNode=vmstorage-1.vmstorage.monitoring.svc.cluster.local:8400",
            "--storageNode=vmstorage-2.vmstorage.monitoring.svc.cluster.local:8400",
            "--envflag.enable=true",
            "--envflag.prefix=VM_",
            "--loggerFormat=json"
          ]
          port {
            name = "http"
            container_port = 8480
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds = 15
            timeout_seconds = 5
            failure_threshold = 3
          }
          liveness_probe {
            tcp_socket {
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds = 15
            timeout_seconds = 5
            failure_threshold = 3
          }
          resources {}
        }
        service_account_name = "victoria-metrics"
      }
    }
  }
}