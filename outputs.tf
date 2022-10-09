output "identity_provider_name" {
  value = google_iam_workload_identity_pool_provider.default.name
}

output "google_service_account_email" {
  value = google_service_account.default.email
}
