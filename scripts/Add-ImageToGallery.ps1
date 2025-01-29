<#
.SYNOPSIS
Adds a managed image to an Azure compute gallery.

.DESCRIPTION
This script adds a managed image to an Azure compute gallery by creating a new image version. 
It requires the resource group name, gallery name, gallery image definition name, managed image resource ID, and the new gallery image version name as parameters.

.PARAMETER ResourceGroupName
The name of the resource group that contains the Azure compute gallery.

.PARAMETER GalleryName
The name of the Azure compute gallery.

.PARAMETER GalleryImageDefinitionName
The name of the gallery image definition.

.PARAMETER ManagedImageResourceId
The resource ID of the managed image to be added to the gallery.

.PARAMETER GalleryImageVersionName
The name of the new gallery image version to be created.

.EXAMPLE
.\Add-ImageToGallery.ps1 -ResourceGroupName "myResourceGroup" -GalleryName "myGallery" -GalleryImageDefinitionName "myImageDefinition" -ManagedImageResourceId "/subscriptions/{subscription-id}/resourceGroups/myResourceGroup/providers/Microsoft.Compute/images/myManagedImage" -GalleryImageVersionName "1.0.0"

This example adds a managed image to the specified Azure compute gallery by creating a new image version with the name "1.0.0".
#>


[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$GalleryName,

    [Parameter(Mandatory=$true)]
    [string]$GalleryImageDefinitionName,

    [Parameter(Mandatory=$true)]
    [string]$ManagedImageResourceId,

    [Parameter(Mandatory=$true)]
    [string]$GalleryImageVersionName
)

try {
    $galImgDefinitionObj = Get-AzGalleryImageDefinition -ResourceGroupName $ResourceGroupName `
                                                        -GalleryName $GalleryName `
                                                        -Name $GalleryImageDefinitionName    
}
catch {
    Write-Host "Gallery image definition not found. Please create it first."
    exit
}

try {
    $managedImageObj = Get-AzResource -ResourceId $ManagedImageResourceId
}
catch {
    Write-Host "Managed image not found. Please create it first."
    exit
}

if($managedImageObj.ResourceType -ne "Microsoft.Compute/images") {
    Write-Host "The provided resource is not a managed image."
    exit
}
else {
    try {
        $newImgVersion = New-AzGalleryImageVersion -ResourceGroupName $ResourceGroupName `
                                                   -GalleryName $GalleryName `
                                                   -GalleryImageDefinitionName $galImgDefinitionObj.Name `
                                                   -Name $GalleryImageVersionName `
                                                   -Location $galImgDefinitionObj.Location `
                                                   -SourceImageId $ManagedImageResourceId   
    }
    catch {
        Write-Host "Failed to create a new image version."
        exit
    }
}

return $newImgVersion