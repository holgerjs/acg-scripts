location = "West Europe"

ubuntu_standard_image_definition = {
    name             = "img_ubuntu_22.04_standard_private_runner"
    architecture     = "x64"
    description      = "Ubuntu 22.04 Standard Private Runner Image"
    osType           = "Linux"
    osState          = "Generalized"
    offer            = "Private_Runner"
    publisher        = "Me"
    sku              = "Ubuntu-22.04_Standard"
    memory_max       = 32
    memory_min       = 4
    vcpus_max        = 16
    vcpus_min        = 2
    hyperVGeneration = "V2"
}

ubuntu_minimal_image_definition = {
    name             = "img_ubuntu_22.04_minimal_private_runner"
    architecture     = "x64"
    description      = "Ubuntu 22.04 Minimal Private Runner Image"
    osType           = "Linux"
    osState          = "Generalized"
    offer            = "Private_Runner"
    publisher        = "Me"
    sku              = "Ubuntu-22.04_Minimal"
    memory_max       = 32
    memory_min       = 4
    vcpus_max        = 16
    vcpus_min        = 2
    hyperVGeneration = "V2"
}