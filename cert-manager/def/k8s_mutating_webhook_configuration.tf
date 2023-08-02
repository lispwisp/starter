resource "kubernetes_mutating_webhook_configuration_v1" "cert-manager-webhook" {
  metadata {
    name = "cert-manager-webhook"
    labels = {
      app = "webhook"
      "app.kubernetes.io/name" = "webhook"
      "app.kubernetes.io/instance" = "cert-manager"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/version" = "v1.12.0"
    }
    annotations = {
      "cert-manager.io/inject-ca-from-secret": "cert-manager/cert-manager-webhook-ca"
    }
  }
  webhook {
    name = "webhook.cert-manager.io"
    rule {
      api_groups   = ["cert-manager.io", "acme.cert-manager.io"]
      api_versions = ["v1"]
      operations   = ["CREATE", "UPDATE"]
      resources    = ["*/*"]
    }
    admission_review_versions = ["v1"]
    match_policy = "Equivalent"
    timeout_seconds = 10
    failure_policy = "Fail"
    side_effects = "None"
    client_config {
      service {
        name      = "cert-manager-webhook"
        namespace = "cert-manager"
        path = "/mutate"
      }
    }
  }
}