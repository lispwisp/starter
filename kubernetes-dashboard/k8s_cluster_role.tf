resource "kubernetes_cluster_role_v1" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources = ["pods", "nodes"]
    verbs = ["get", "list", "watch"]
  }
}