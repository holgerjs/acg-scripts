resource "random_id" "deployment_suffix" {
  byte_length = 8
}

variable "location" {
  description = "The region where the resource group will be created."
  type        = string
}

variable "ubuntu_standard_image_definition" {
  description = "The name of the standard image definition."
  type = object({
    name             = string
    architecture     = string
    description      = string
    osType           = string
    osState          = string
    offer            = string
    publisher        = string
    sku              = string
    memory_max       = number
    memory_min       = number
    vcpus_max        = number
    vcpus_min        = number
    hyperVGeneration = string
  })
}

variable "ubuntu_minimal_image_definition" {
  description = "The name of the minimal image definition."
  type = object({
    name             = string
    architecture     = string
    description      = string
    osType           = string
    osState          = string
    offer            = string
    publisher        = string
    sku              = string
    memory_max       = number
    memory_min       = number
    vcpus_max        = number
    vcpus_min        = number
    hyperVGeneration = string
  })
}