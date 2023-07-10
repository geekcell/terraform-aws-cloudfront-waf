# Context
variable "name" {
  description = "Friendly name of the ACL."
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to add to the Resources."
  type        = map(any)
}
