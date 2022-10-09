variable "project_id" {
  type = string
}

variable "repo" {
  type = string
}

variable "project_admins" {
  type = map(string)
}

variable "service_account" {
  type = object({
    account_id   = string
    display_name = string
  })
}
