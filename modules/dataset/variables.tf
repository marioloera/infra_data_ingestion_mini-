variable "id" {
  description = "The id of the dataset. Will be used as prefix before tables when querying."
  type        = string
}

variable "description" {
  description = "Helpful text to describe the dataset to users. Visible in the GUI."
  type        = string
}

variable "label_make_sync_bq" {
  description = "Sets a label called make-sync-bq on the dataset. Used by application logic."
  type        = bool
  default     = false
}

variable "default_table_expiration_ms" {
  description = "Tables older than this figure will be automatically deleted"
  type        = number
  default     = null
}

variable "default_partition_expiration_ms" {
  description = "Table parttions older than this figure will be automatically deleted"
  type        = number
  default     = 4000 * 24 * 3600 * 1000 # 4000 days
}

# ******************* IAM ROLES *******************
variable "data_owners" {
  description = "Data owners for the dataset"
  type        = list(string)
  default     = []
}

variable "data_viewers" {
  description = "Data viewers for the dataset"
  type        = list(string)
  default     = []
}

variable "data_editors" {
  description = "Data editors for the dataset"
  type        = list(string)
  default     = []
}


# Add one variable for each other role below.
/*variable "data_editors" {
  description = "Data editors for the dataset"
  type        = list(string)
  default     = []
}*/
