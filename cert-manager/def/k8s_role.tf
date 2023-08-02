resource "kubernetes_role_v1" "cert-manager-cainjector-leaderelection" {
  metadata {
    name = "cert-manager-cainjector:leaderelection"
    namespace = "kube-system"
    labels = {
      app = "cainjector"
      "app.kubernetes.io/name" = "cainjector"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    resource_names = ["cert-manager-cainjector-leader-election", "cert-manager-cainjector-leader-election-core"]
    verbs = ["get", "update", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    verbs = ["create"]
  }
}

resource "kubernetes_role_v1" "cert-manager-leaderelection" {
  metadata {
    name = "cert-manager:leaderelection"
    namespace = "kube-system"
    labels = {
      app = "cert-manager"
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    resource_names = ["cert-manager-controller"]
    verbs = ["get", "update", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    verbs = ["create"]
  }
}

resource "kubernetes_role_v1" "cert-manager-webhook-dynamic-serving" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager
  ]
  metadata {
    name = "cert-manager-webhook:dynamic-serving"
    namespace = "cert-manager"
    labels = {
      app = "webhook"
      "app.kubernetes.io/name" = "webhook"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    resource_names = ["cert-manager-webhook-ca"]
    verbs = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create"]
  }
}