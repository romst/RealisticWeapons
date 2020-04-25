$modName = "RealisticWeapons"

if ($PSScriptRoot -notmatch "Mount & Blade II Bannerlord\\Modules\\$modName\\install_files$") {
    Write-Output "Invalid folder: '$PSScriptRoot'. Please place this script in the folder 'Mount & Blade II Bannerlord/Modules/$modName'."
} else {
    # Install characters
    $pathModifiedCharacters = "$PSScriptRoot/modified_spnpccharacters.xml"
    $pathTargetCharacters = "$PSScriptRoot/../../SandBoxCore/ModuleData/spnpccharacters.xml"

    Copy-Item -Path $pathModifiedCharacters -Destination $pathTargetCharacters -Recurse
    Write-Output "$pathTargetCharacters replaced."

    # Install chrafting pieces
    $pathModifiedCraftingPieces = "$PSScriptRoot/modified_crafting_pieces.xml"
    $pathTargetCraftingPieces = "$PSScriptRoot/../../Native/ModuleData/crafting_pieces.xml"

    Copy-Item -Path $pathModifiedCraftingPieces -Destination $pathTargetCraftingPieces -Recurse
    Write-Output "$pathTargetCraftingPieces replaced."

    Write-Output "Done."
}