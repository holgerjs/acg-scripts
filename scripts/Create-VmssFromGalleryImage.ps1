<#
.SYNOPSIS
Creates a Virtual Machine Scale Set (VMSS) from a specified gallery image.

.DESCRIPTION
This script automates the process of creating a Virtual Machine Scale Set (VMSS) using a specified image from an Azure Shared Image Gallery. It allows for customization of various parameters such as the resource group, VMSS name, instance count, and more.

.PARAMETER ResourceGroupName
Specifies the name of the resource group where the VMSS will be created.

.PARAMETER VmssName
Specifies the name of the Virtual Machine Scale Set.

.PARAMETER ImageGalleryName
Specifies the name of the Shared Image Gallery containing the image to be used.

.PARAMETER ImageDefinitionName
Specifies the name of the image definition within the Shared Image Gallery.

.PARAMETER ImageVersion
Specifies the version of the image to be used.

.PARAMETER InstanceCount
Specifies the number of instances to be created in the VMSS.

.PARAMETER VmSize
Specifies the size of the virtual machines in the VMSS.

.EXAMPLE
.\Create-VmssFromGalleryImage.ps1 -ResourceGroupName "MyResourceGroup" -VmssName "MyVmss" -ImageGalleryName "MyGallery" -ImageDefinitionName "MyImage" -ImageVersion "1.0.0" -InstanceCount 3 -VmSize "Standard_DS1_v2"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$Location,

    [Parameter(Mandatory=$true)]
    [string]$SkuName,

    [Parameter(Mandatory=$true)]
    [int]$SkuCapacity,

    [Parameter(Mandatory=$true)]
    [string]$OrchestrationMode,

    [Parameter(Mandatory=$true)]
    [string]$VmssName,

    [Parameter(Mandatory=$true)]
    [string]$SubnetId,

    [Parameter(Mandatory=$true)]
    [string]$VmssNodePrefix,

    [Parameter(Mandatory=$true)]
    [string]$VmssAdminUserName,

    [Parameter(Mandatory=$true)]
    [string]$GalleryResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$GalleryName,

    [Parameter(Mandatory=$true)]
    [string]$GalleryImageDefinitionName,

    [Parameter(Mandatory=$false)]
    [string]$GalleryImageVersionName
)

try {
    # Get the resource group object
    $rgObj = Get-AzResourceGroup -ResourceGroupName $ResourceGroupName -ErrorAction Stop
}
catch {
    Write-Host "Resource group not found."
    exit
}

try {
    # Get the gallery image definition object
    $galleryImgDefinitionObj = Get-AzGalleryImageDefinition -ResourceGroupName $GalleryResourceGroupName -GalleryName $GalleryName -Name $GalleryImageDefinitionName -ErrorAction Stop
}
catch {
    Write-Host "Gallery image definition not found."
    exit
}

try {
    if(!$GalleryImageVersionName) {
        # Get the latest version of the gallery image if the version is not provided and the cmdlet returns multiple versions
        $galleryImgVersionObj = Get-AzGalleryImageVersion -ResourceGroupName $GalleryResourceGroupName -GalleryName $GalleryName -GalleryImageDefinitionName $GalleryImageDefinitionName | Sort-Object Name -Descending | Select-Object -First 1 -ErrorAction Stop
    }
    else {
        # Get the specific version of the gallery image if the version is provided
        $galleryImgVersionObj = Get-AzGalleryImageVersion -ResourceGroupName $GalleryResourceGroupName -GalleryName $GalleryName -GalleryImageDefinitionName $GalleryImageDefinitionName -Name $GalleryImageVersionName -ErrorAction Stop
    }
}
catch {
    Write-Host "Gallery image version not found."
    exit
}

# Create the VMSS configuration
$vmssMainConfig = @{
    Location = $Location
    SkuCapacity = $SkuCapacity
    SkuName = $SkuName
    UpgradePolicyMode = 'Manual'
    OrchestrationMode = $OrchestrationMode
    SinglePlacementGroup = $true
    Overprovision = $false
}

# Create the VMSS network configuration
$vmssNetworkConfig = @{
    Name = 'Nic01'
    SubnetId = $SubnetId
    Primary = $true
}

# Create the VMSS NIC configuration
$vmssNetworkInterfaceConfig = @{
    Name = 'Nic01'
    Primary = $true
    IpConfiguration = New-AzVmssIpConfig @vmssNetworkConfig
}

# Create the VMSS storage profile
$vmssStorageProfile = @{
    ImageReferenceId = $galleryImgVersionObj.Id
    OSDiskSizeGB = $galleryImgVersionObj.StorageProfile.OsDiskImage.SizeInGB
    OsDiskOsType = $galleryImgDefinitionObj.OsType
    OsDiskCreateOption = 'FromImage'
    ManagedDisk = $galleryImgVersionObj.PublishingProfile.TargetRegions[0].StorageProfile.OsDisk
}

# Create the VMSS OS profile
$vmssOsProfile = @{
    ComputerNamePrefix = $VmssNodePrefix  
    AdminUsername = $VmssAdminUserName
    AdminPassword = $((New-Guid).ToString())
}

# Create the joint VMSS configuration
$vmssConfig = New-AzVmssConfig @vmssMainConfig
$vmssConfig | Set-AzVmssStorageProfile @vmssStorageProfile
$vmssConfig | Set-AzVmssOsProfile @vmssOsProfile
$vmssConfig | Add-AzVmssNetworkInterfaceConfiguration @vmssNetworkInterfaceConfig

# Create the VMSS
$vmss = New-AzVmss -ResourceGroupName $rgObj.ResourceGroupName `
                   -VMScaleSetName $VmssName `
                   -VirtualMachineScaleSet $vmssConfig

return $vmss