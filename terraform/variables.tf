resource "random_id" "deployment_suffix" {
  byte_length = 8
}

variable "location" {
  description = "The region where the resource group will be created."
  type        = string
  default     = "westeurope"
}