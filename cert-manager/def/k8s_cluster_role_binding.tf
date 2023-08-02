resource "kubernetes_cluster_role_binding_v1" "cert-manager-cainjector" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-cainjector
  ]
  metadata {
    name = "cert-manager-cainjector"
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
    kind      = "ClusterRole"
    name      = "cert-manager-cainjector"
  }
  subject {
    name = "cert-manager-cainjector"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-issuers" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-issuers
  ]
  metadata {
    name = "cert-manager-controller-issuers"
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
    kind      = "ClusterRole"
    name      = "cert-manager-controller-issuers"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-clusterissuers" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-clusterissuers
  ]
  metadata {
    name = "cert-manager-controller-clusterissuers"
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
    kind      = "ClusterRole"
    name      = "cert-manager-controller-clusterissuers"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-certificates" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-certificates
  ]
  metadata {
    name = "cert-manager-controller-certificates"
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
    kind      = "ClusterRole"
    name      = "cert-manager-controller-certificates"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-orders" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-orders
  ]
  metadata {
    name = "cert-manager-controller-orders"
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
    kind      = "ClusterRole"
    name      = "cert-manager-controller-orders"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-challenges" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-challenges
  ]
  metadata {
    name = "cert-manager-controller-challenges"
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
    kind      = "ClusterRole"
    name      = "cert-manager-controller-challenges"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-ingress-shim" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-ingress-shim
  ]
  metadata {
    name = "cert-manager-controller-ingress-shim"
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
    kind      = "ClusterRole"
    name      = "cert-manager-controller-ingress-shim"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-approve-cert-manager-io" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-approve-cert-manager-io
  ]
  metadata {
    name = "cert-manager-controller-approve:cert-manager-io"
    labels = {
      app = "cert-manager"
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "cert-manager"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager-controller-approve:cert-manager-io"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-controller-certificatesigningrequests" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-controller-certificates
  ]
  metadata {
    name = "cert-manager-controller-certificatesigningrequests"
    labels = {
      app = "cert-manager"
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "cert-manager"
      "app.kubernetes.io/version" = "v1.12.0"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager-controller-certificatesigningrequests"
  }
  subject {
    name = "cert-manager"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}

resource "kubernetes_cluster_role_binding_v1" "cert-manager-webhook-subjectaccessreviews" {
  depends_on = [
    kubernetes_cluster_role_v1.cert-manager-webhook-subjectaccessreviews
  ]
  metadata {
    name = "cert-manager-webhook:subjectaccessreviews"
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
    kind      = "ClusterRole"
    name      = "cert-manager-webhook:subjectaccessreviews"
  }
  subject {
    api_group = ""
    name = "cert-manager-webhook"
    namespace = "cert-manager"
    kind = "ServiceAccount"
  }
}