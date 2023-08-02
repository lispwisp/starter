resource "kubernetes_role_binding_v1" "cert-manager-cainjector-leaderelection" {
  depends_on = [
    kubernetes_role_v1.cert-manager-cainjector-leaderelection
  ]
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
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cert-manager-cainjector:leaderelection"
  }
  subject {
    kind = "ServiceAccount"
    name = "cert-manager-cainjector"
    namespace = "cert-manager"
  }
}

resource "kubernetes_role_binding_v1" "cert-manager-leaderelection" {
  depends_on = [
    kubernetes_role_v1.cert-manager-leaderelection
  ]
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
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cert-manager:leaderelection"
  }
  subject {
    api_group = ""
    kind = "ServiceAccount"
    name = "cert-manager"
    namespace = "cert-manager"
  }
}

resource "kubernetes_role_binding_v1" "cert-manager-webhook-dynamic-serving" {
  depends_on = [
    kubernetes_namespace_v1.cert-manager,
    kubernetes_role_v1.cert-manager-webhook-dynamic-serving
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
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cert-manager-webhook:dynamic-serving"
  }
  subject {
    api_group = ""
    kind = "ServiceAccount"
    name = "cert-manager-webhook"
    namespace = "cert-manager"
  }
}