if ($PSScriptRoot -notmatch 'Mount & Blade II Bannerlord\\Modules\\RealisticWeapons') {
    Write-Output "Invalid folder: '$PSScriptRoot'. Please place this script in the folder 'Mount & Blade II Bannerlord/Modules/RealisticWeapons'."
} else {
    Copy-Item -Path "$PSScriptRoot/install_files/orig_spnpccharacters.xml" -Destination "$PSScriptRoot/../SandBoxCore/ModuleData/spnpccharacters.xml" -Recurse
    Write-Output "Success"
}

Read-Host -Prompt "Press 'Enter' to exit"