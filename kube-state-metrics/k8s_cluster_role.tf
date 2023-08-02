resource "kubernetes_cluster_role_v1" "kube-state-metrics" {
  metadata {
    name = "kube-state-metrics"
    labels = {
      "app.kubernetes.io/component" = "exporter"
      "app.kubernetes.io/name" = "kube-state-metrics"
      "app.kubernetes.io/version" = "2.8.0"
    }
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = [""]
    resources = [
      "configmaps",
      "secrets",
      "nodes",
      "pods",
      "services",
      "serviceaccounts",
      "resourcequotas",
      "replicationcontrollers",
      "limitranges",
      "persistentvolumeclaims",
      "persistentvolumes",
      "namespaces",
      "endpoints"
    ]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["apps"]
    resources = [
      "statefulsets",
      "daemonsets",
      "deployments",
      "replicasets"
    ]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["batch"]
    resources = ["cronjobs", "jobs"]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources = ["horizontalpodautoscalers"]
  }
  rule {
    verbs = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources = ["tokenreviews"]
  }
  rule {
    verbs = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources = ["subjectaccessreviews"]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources = ["certificatesigningrequests"]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["discovery.k8s.io"]
    resources = ["endpointslices"]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources = ["storageclasses", "volumeattachments"]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources = [
      "mutatingwebhookconfigurations",
      "validatingwebhookconfigurations"
    ]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources = [
      "networkpolicies",
      "ingressclasses",
      "ingresses"
    ]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources = [
      "leases"
    ]
  }
  rule {
    verbs = ["list", "watch"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources = [
      "clusterrolebindings",
      "clusterroles",
      "rolebindings",
      "roles"
    ]
  }
}