variable "gcp_project" {
  description = "project id of the bucket."
  type        = string
}

variable "name" {
  description = "Name of the bucket."
  type        = string
}

variable "delete_after_days" {
  description = "Number of days to keep objects before auto deletion"
  type        = number
  default     = -1 # Will result in no lifecycle rule being set
}

# ******************* IAM ROLES *******************
variable "object_admin" {
  description = "roles/storage.objectAdmin for the bucket"
  type        = list(string)
  default     = []
}

variable "object_viewer" {
  description = "roles/storage.objectViewer for the bucket"
  type        = list(string)
  default     = []
}

variable "storage_admin" {
  description = "roles/storage.admin for the bucket"
  type        = list(string)
  default     = []
}

# Add one variable for each new role below.
/*variable "some_other_storage_role" {
  description = "roles/storage.objectAdmin for the bucket"
  type        = list(string)
  default     = []
}*/
