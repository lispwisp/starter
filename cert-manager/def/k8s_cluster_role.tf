resource "kubernetes_cluster_role_v1" "cert-manager-cainjector" {
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
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["get", "create", "update", "patch"]
  }
  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
    verbs = ["get", "list", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["apiregistration.k8s.io"]
    resources = ["apiservices"]
    verbs = ["get", "list", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources = ["customresourcedefinitions"]
    verbs = ["get", "list", "watch", "update", "patch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-issuers" {
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
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["issuers", "issuers/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch", "create", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-clusterissuers" {
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
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers", "clusterissuers/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch", "create", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-certificates" {
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
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificates/status", "certificaterequests", "certificaterequests/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "clusterissuers", "issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates/finalizers", "certificaterequests/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders"]
    verbs = ["create", "delete", "get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-orders" {
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
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders", "orders/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders", "challenges"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers", "issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges"]
    verbs = ["create", "delete"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-challenges" {
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
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges", "challenges/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["issuers", "clusterissuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
  rule {
    api_groups = [""]
    resources = ["pods", "services"]
    verbs = ["get", "list", "watch", "create", "delete"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch", "create", "delete", "update"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources = ["httproutes"]
    verbs = ["get", "list", "watch", "create", "delete", "update"]
  }
  rule {
    api_groups = ["route.openshift.io"]
    resources = ["routes/custom-host"]
    verbs = ["create"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-ingress-shim" {
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
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests"]
    verbs = ["create", "update", "delete"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "issuers", "clusterissuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources = ["gateways", "httproutes"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources = ["gateways/finalizers", "httproutes/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-view" {
  metadata {
    name = "cert-manager-view"
    labels = {
      app = "cert-manager"
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/version" = "v1.12.0"
      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges", "orders"]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-edit" {
  metadata {
    name = "cert-manager-edit"
    labels = {
      app = "cert-manager"
      "app.kubernetes.io/name" = "cert-manager"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/version" = "v1.12.0"
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "issuers"]
    verbs = ["create", "delete", "deletecollection", "patch", "update"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates/status"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges", "orders"]
    verbs = ["create", "delete", "deletecollection", "patch", "update"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-approve-cert-manager-io" {
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
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["signers"]
    verbs = ["approve"]
    resource_names = ["issuers.cert-manager.io/*", "clusterissuers.cert-manager.io/*"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-controller-certificatesigningrequests" {
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
  rule {
    api_groups = ["certificates.k8s.io"]
    resources = ["certificatesigningrequests"]
    verbs = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = ["certificates.k8s.io"]
    resources = ["certificatesigningrequests/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["certificates.k8s.io"]
    resources = ["signers"]
    resource_names = ["issuers.cert-manager.io/*", "clusterissuers.cert-manager.io/*"]
    verbs = ["sign"]
  }
  rule {
    api_groups = ["authorization.k8s.io"]
    resources = ["subjectaccessreviews"]
    verbs = ["create"]
  }
}

resource "kubernetes_cluster_role_v1" "cert-manager-webhook-subjectaccessreviews" {
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
  rule {
    api_groups = ["authorization.k8s.io"]
    resources = ["subjectaccessreviews"]
    verbs = ["create"]
  }
}