resource "random_id" "deployment_suffix" {
  byte_length = 8
}

variable "location" {
  description = "The region where the resource group will be created."
  type        = string
  default     = "westeurope"
}

variable "ubuntu_image_definition" {
  description = "The name of the image definition."
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
  })
  default = {
    name             = "img_ubuntu-22.04_private-runner"
    architecture     = "x64"
    description      = "Ubuntu 22.04 Private Runner Image"
    osType           = "Linux"
    osState          = "Generalized"
    offer            = "Private_Runner"
    publisher        = "Me"
    sku              = "Ubuntu-22.04_Standard"
    memory_max       = 32
    memory_min       = 4
    vcpus_max        = 16
    vcpus_min        = 2
  }
}