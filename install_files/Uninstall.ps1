$modName = "RealisticWeapons"

if ($PSScriptRoot -notmatch "Mount & Blade II Bannerlord\\Modules\\$modName\\install_files$") {
    Write-Output "Invalid folder: '$PSScriptRoot'. Please place this script in the folder 'Mount & Blade II Bannerlord/Modules/$modName'."
} else {
    # Revert changes to characters
    $pathOriginalCharacters = "$PSScriptRoot/orig_spnpccharacters.xml"
    $pathModifiedCharacters = "$PSScriptRoot/modified_spnpccharacters.xml"
    $pathTargetCharacters = "$PSScriptRoot/../../SandBoxCore/ModuleData/spnpccharacters.xml"

    #Write-Output "Target: $(Get-FileHash -Path $pathTargetCharacters)"
    #Write-Output "Original: $(Get-FileHash -Path $pathOriginalCharacters)"
    #Write-Output "Modified: $(Get-FileHash -Path $pathModifiedCharacters)"

    if ((Get-FileHash -Path $pathModifiedCharacters).hash -eq (Get-FileHash -Path $pathTargetCharacters).hash) {
        Copy-Item -Path $pathOriginalCharacters -Destination $pathTargetCharacters -Recurse
        Write-Output "$pathTargetCharacters restored."
    } else {
        Write-Output "$pathTargetCharacters already is an original file."
    }

    # Revert changes to creafting pieces
    $pathOriginalCraftingPieces = "$PSScriptRoot/orig_crafting_pieces.xml"
    $pathModifiedCraftingPieces = "$PSScriptRoot/modified_crafting_pieces.xml"
    $pathTargetCraftingPieces = "$PSScriptRoot/../../Native/ModuleData/crafting_pieces.xml"
    
    if ((Get-FileHash -Path $pathModifiedCraftingPieces).hash -eq (Get-FileHash -Path $pathTargetCraftingPieces).hash) {
        Copy-Item -Path $pathOriginalCraftingPieces -Destination $pathTargetCraftingPieces -Recurse
        Write-Output "$pathTargetCraftingPieces restored."
    } else {
        Write-Output "$pathTargetCraftingPieces already is an original file."
    }

    Write-Output "Done."
}