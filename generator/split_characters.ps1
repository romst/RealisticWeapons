$fileName = 'modified_spnpccharacters'
$logTarget = "$PSScriptRoot/generated/result_characters.csv"

Remove-Item -path "$PSScriptRoot/generated/ModuleData/" -include *.xml -Recurse
Remove-Item -path "$PSScriptRoot/generated/" -include *.csv -Recurse

Write-Output "Character`tItem0`tItem1`tItem2`tItem3`tRemovedWeapon" >> $logTarget

function LoadXml([String] $relativePath){
    $xml = New-Object System.XML.XMLDocument
    return $xml, $xml.Load("$PSScriptRoot/$relativePath")
}

function SaveXml([System.XML.XMLDocument] $doc, [string] $relativePath) {
    $fs = new-object IO.FileStream("$PSScriptRoot/$relativePath", [IO.FileMode]::OpenOrCreate)
    $doc.Save($fs)
    $fs.Flush()
    $fs.Close()
}

# Generate crafting_pieces.xml
$xml_spnpccharacters = LoadXml("source_data/spnpccharacters.xml")

$xml_spnpccharacters.SelectNodes('//NPCCharacter') | ForEach-Object{
    # Create node for piece
    $character = $_
    
    $Script:modified = $false
    
    if ($character) {# -and ('Soldier','Mercenary','CaravanGuard' -contains $character.occupation) -and ($character.default_group -eq 'Infantry')) {
        $character.equipmentSet | ForEach-Object{
            $log = "$($character.id)"

            $equipmentSet = $_
            $Script:spear = $null
            $Script:sidearm = $null

            $itemCount = 0
            $equipmentSet.equipment | ForEach-Object{
                $equipment = $_

                if ($equipment.slot -like 'Item?') {
                    $log += "`t$($equipment.id)"
                    $itemCount += 1
                    if ($equipment.id -like '*_spear_*' -and $equipment.id -notlike '*_throwing_spear_*') {
                        $Script:spear = $equipment
                    } elseif (($equipment.id -like '*_sword_*' -and $equipment.id -notlike '*bastard_sword_*') -or $equipment.id -like '*_mace_*' -or ($equipment.id -like '*_axe_*' -and $equipment.id -notlike '*_throwing_axe_*')) {
                        $Script:sidearm = $equipment
                    }
                }
            }

            while ($itemCount -lt 4) {
                $log += "`t"
                $itemCount += 1
            }

            
            if ($spear -and $sidearm) {
                $sidearm.ParentNode.RemoveChild($sidearm) | Out-Null
                $Script:modified = $true
                $log += "`t$($sidearm.id)"
            }
            Write-Output $log >> $logTarget
        }
    }

    if (!$modified) {
        $xml_spnpccharacters.NPCCharacters.RemoveChild($character) | Out-Null
    }
}

# Save pieces in new file
SaveXml $xml_spnpccharacters "generated/ModuleData/$fileName.xml"

Write-Output "Done"