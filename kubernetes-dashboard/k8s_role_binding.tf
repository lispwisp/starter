resource "kubernetes_role_binding_v1" "kubernetes-dashboard" {
  depends_on = [
    kubernetes_namespace_v1.kubernetes-dashboard,
    kubernetes_role_v1.kubernetes-dashboard
  ]
  metadata {
    name = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
    labels = {
      "app.kubernetes.io/part-of" = "kubernetes-dashboard"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "kubernetes-dashboard"
  }
  subject {
    kind = "ServiceAccount"
    name = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }
}