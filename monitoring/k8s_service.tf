resource "kubernetes_service_v1" "vminsert" {
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
    port {
      name = "http"
      port = 8480
      protocol = "TCP"
      target_port = "http"
    }
    selector = {
      app = "vminsert"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "vmselect" {
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
    port {
      name = "http"
      port = 8481
      protocol = "TCP"
      target_port = "http"
    }
    selector = {
      app = "vmselect"
    }
    cluster_ip = "None"
  }
}

resource "kubernetes_service_v1" "vmstorage" {
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
    port {
      name = "http"
      port = 8482
      protocol = "TCP"
      target_port = "http"
    }
    port {
      name = "vmselect"
      port = 8401
      target_port = "vmselect"
      protocol = "TCP"
    }
    port {
      name = "vminsert"
      port = 8400
      target_port = "vminsert"
      protocol = "TCP"
    }
    selector = {
      app = "vmstorage"
    }
    cluster_ip = "None"
  }
}

resource "kubernetes_service_v1" "vmagent" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "vmagent"
    namespace = "monitoring"
  }
  spec {
    port {
      name = "http"
      port = 8429
      protocol = "TCP"
      target_port = "http"
    }
    selector = {
      app = "vmagent"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "grafana" {
  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
  metadata {
    name = "grafana"
    namespace = "monitoring"
    labels = {
      app = "grafana"
    }
  }
  spec {
    type = "NodePort"
    session_affinity = "ClientIP"
    port {
      port = 80
      target_port = 3000
    }
    selector = {
      app = "grafana"
    }
  }
}