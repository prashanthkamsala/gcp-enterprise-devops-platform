resource "google_monitoring_alert_policy" "order_api_restarts" {
  project      = var.project_id
  display_name = "Order API - Unexpected Container Restarts"
  combiner     = "OR"
  enabled      = true

  documentation {
    content   = "Order API container restarted. Check Kubernetes events, container logs, resource limits, and probe failures. See docs/runbooks/order-api-incident-response.md."
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "Order API container restart detected"

    condition_threshold {
      filter = join(" AND ", [
        "resource.type=\"k8s_container\"",
        "metric.type=\"kubernetes.io/container/restart_count\"",
        "resource.labels.namespace_name=\"order-platform\"",
        "resource.labels.container_name=\"order-api\""
      ])

      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_DELTA"
      }

      trigger {
        count = 1
      }
    }
  }

  user_labels = {
    application = "order-api"
    environment = "dev"
    managed_by  = "terraform"
  }
}