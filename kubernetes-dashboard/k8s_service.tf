resource "kubernetes_service_v1" "kubernetes-dashboard-web" {
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
    port {
      name = "web"
      port = 8000
    }
    selector = {
      "app.kubernetes.io/name" = "kubernetes-dashboard-web"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
}

resource "kubernetes_service_v1" "kubernetes-dashboard-api" {
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
    port {
      name = "api"
      port = 9000
    }
    selector = {
      "app.kubernetes.io/name" = "kubernetes-dashboard-api"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
}

resource "kubernetes_service_v1" "kubernetes-dashboard-metrics-scraper" {
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
    port {
      port = 8000
      target_port = 8000
    }
    selector = {
      "app.kubernetes.io/name" = "kubernetes-dashboard-metrics-scraper"
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
}