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
The resource ID of the managed image to be added to the gallery. This can either be the resource id of a managed image or a gallery image.

.PARAMETER GalleryImageVersionName
The name of the new gallery image version to be created. If not provided, a new version name will be generated based on the current year and month.

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

    [Parameter(Mandatory=$false)]
    [string]$GalleryImageVersionName
)

$boldStart = "`e[1m"
$boldEnd = "`e[0m"

Write-Host "Adding a new image version to the gallery."

Write-Host "Retrieving gallery image definition for ${boldStart}$GalleryImageDefinitionName${boldEnd} in ${boldStart}$GalleryName${boldEnd} gallery."
try {
    $galImgDefinitionObj = Get-AzGalleryImageDefinition -ResourceGroupName $ResourceGroupName `
                                                        -GalleryName $GalleryName `
                                                        -Name $GalleryImageDefinitionName    
}
catch {
    Write-Host "Gallery image definition not found. Please create it first."
    exit
}

if(!$GalleryImageVersionName) {
    Write-Host "Generating a new version name for the image since no version was provided."
    $currentYearMonth = (Get-Date).ToString("yyyy.M")
    $existingVersions = (Get-AzGalleryImageVersion -ResourceGroupName $ResourceGroupName -GalleryName $GalleryName -GalleryImageDefinitionName $GalleryImageDefinitionName).Name
    $matchingVersions = $existingVersions | Where-Object { $_ -match "$currentYearMonth\.\d+" }

    if ($matchingVersions) {
        $increments = $matchingVersions | ForEach-Object {
            $_ -replace "$currentYearMonth\.", ""
        } | ForEach-Object {
            [int]$_
        } | Sort-Object -Descending
        
        $newVersionIncrement = $increments[0] + 1
    } else {
        $newVersionIncrement = 1
    }

    $newVersionName = "$currentYearMonth.$newVersionIncrement"
}
else {
    $newVersionName = $GalleryImageVersionName
}

Write-Host "Using ${boldStart}$newVersionName${boldEnd} as the new image version name."


Write-Host "Retrieving managed image with ID ${boldStart}$ManagedImageResourceId${boldEnd}."
try {
    $managedImageObj = Get-AzResource -ResourceId $ManagedImageResourceId
}
catch {
    Write-Host "Managed image not found. Please create it first."
    exit
}

if($managedImageObj.ResourceType -ne "Microsoft.Compute/images" -and $managedImageObj.ResourceType -ne "Microsoft.Compute/galleries/images") {
    Write-Host "The provided resource is not a managed image or a gallery image."
    exit
}
else {
    Write-Host "Creating a new image version for the managed image."
    try {
        $newImgVersion = New-AzGalleryImageVersion -ResourceGroupName $ResourceGroupName `
                                                   -GalleryName $GalleryName `
                                                   -GalleryImageDefinitionName $galImgDefinitionObj.Name `
                                                   -Name $newVersionName `
                                                   -Location $galImgDefinitionObj.Location `
                                                   -SourceImageId $ManagedImageResourceId   
    }
    catch {
        Write-Host "Failed to create a new image version."
        exit
    }
}

return $newImgVersion