resource "kubernetes_daemon_set_v1" "node-exporter" {
  depends_on = [
    kubernetes_namespace_v1.node-exporter
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "exporter"
      "app.kubernetes.io/name" = "node-exporter"
    }
    name = "node-exporter"
    namespace = "node-exporter"
  }
  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "exporter"
        "app.kubernetes.io/name" = "node-exporter"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "exporter"
          "app.kubernetes.io/name" = "node-exporter"
        }
      }
      spec {
        volume {
          host_path {
            path = "/sys"
          }
          name = "sys"
        }
        volume {
          host_path {
            path = "/"
          }
          name = "root"
        }
        volume {
          host_path {
            path = "/dev"
          }
          name = "dev"
        }
        volume {
          host_path {
            path = "/proc"
          }
          name = "proc"
        }
        container {
          volume_mount {
            mount_path = "/host/sys"
            mount_propagation = "HostToContainer"
            name       = "sys"
            read_only = true
          }
          volume_mount {
            mount_path = "/host/root"
            mount_propagation = "HostToContainer"
            name       = "root"
            read_only = true
          }
          volume_mount {
            mount_path = "/host/dev"
            mount_propagation = "HostToContainer"
            name       = "dev"
            read_only = true
          }
          volume_mount {
            mount_path = "/host/proc"
            mount_propagation = "HostToContainer"
            name       = "proc"
            read_only = true
          }
          name = "node-exporter"
          image = "bitnami/node-exporter:latest"
          args = [
            "--path.sysfs=/host/sys",
            "--path.rootfs=/host/root",
            "--path.procfs=/host/proc",
            "--no-collector.wifi",
            "--no-collector.hwmon",
            "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/pods/.+)($|/)",
            "--collector.netclass.ignored-devices=^(veth.*)$"
          ]
          port {
            container_port = 9100
          }
          resources {
            limits = {
              cpu = "100m"
              memory = "100Mi"
            }
            requests = {
              cpu = "10m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}