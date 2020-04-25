$fileName = 'modified_spnpccharacters'
$logTarget = "$PSScriptRoot/generated/result_characters.csv"

Remove-Item -path "$PSScriptRoot/generated/" -include *.xml -Recurse
Remove-Item -path "$PSScriptRoot/generated/" -include *.csv -Recurse

Write-Output "Character`tItem0`tItem1`tItem2`tItem3`tSpearUpgrade`tRemovedWeapon`tNewWeapon" >> $logTarget

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

function IsSpear($weapon) {
    return ($weapon.id -notmatch '_throwing_spear_') -and (($weapon.id -match '_spear_') -or ($weapon.id -match '_pitchfork_') -or ($weapon.id -match '_polearm_') -or ($weapon.id -match '_fork_') -or ($weapon.id -match '_lance_') -or ($weapon.id -match '_pike_'))
}

function IsSword($weapon) {
    return $weapon.id -match '_sword_'
}

function IsMace($weapon) {
    return ($equipment.id -match '_mace_') -or ($weapon -match '_hammer_')
}

function IsAxe($weapon) {
    return ($weapon.id -notmatch '_throwing_axe_') -and (($weapon.id -match '_axe_') -or ($weapon -match '_sickle_') -or ($weapon -match '_pickaxe_') -or ($weapon -match '_hatchet_'))
}

function UpgradeSpear([ref] $logAppender, $spearForUpgrade, $sideArmToRemove) {
    # basic replacement without regaring culture
    # might add more variety in the future
    if (($sideArmToRemove.id -match '_t3$') -and ($spearForUpgrade.id -match '_t[1-2]$')) {
        $spearForUpgrade.id = 'Item.western_spear_3_t3'
        $logAppender.Value += "`t$($spearForUpgrade.id)"
    } elseif (($sideArmToRemove.id -match '_t4$') -and ($spearForUpgrade.id -match '_t[1-3]$')) {
        $spearForUpgrade.id = 'Item.western_spear_4_t4'
        $logAppender.Value += "`t$($spearForUpgrade.id)"
    } elseif (($sideArmToRemove.id -match '_t5$') -and ($spearForUpgrade.id -match '_t[1-4]$')) {
        $spearForUpgrade.id = 'Item.northern_spear_4_t5'
        $logAppender.Value += "`t$($spearForUpgrade.id)"
    } elseif (($sideArmToRemove.id -match '_t[6-9]$') -and ($spearForUpgrade.id -match '_t[1-9]$')) {
        # no tier 6+ weapons yet, just in case :)
        $spearForUpgrade.id = 'Item.eastern_throwing_spear_1_t4'
        $logAppender.Value += "`t$($spearForUpgrade.id)"
    } else {
        # don't modify the spear
        $logAppender.Value += "`t"
    }
}

function ReplaceSidearm($sideArmToReplace) {
    #units will use real throwing weapons as one-handed melee instead of actually throwing it
    #$sideArmToReplace.id = 'Item.throwing_stone'
}

# Generate crafting_pieces.xml
$xml_spnpccharacters = LoadXml("source_data/spnpccharacters.xml")

$xml_spnpccharacters.SelectNodes('//NPCCharacter') | ForEach-Object{
    # Create node for piece
    $character = $_
    
    $Script:modified = $false
    
    if ($character) {
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
                    if (IsSpear $equipment) {
                        $Script:spear = $equipment
                    } elseif ((IsSword $equipment) -or (IsMace $equipment) -or (IsAxe $equipment)) {
                        $Script:sidearm = $equipment
                    }
                }
            }

            while ($itemCount -lt 4) {
                $log += "`t"
                $itemCount += 1
            }

            if ($spear -and $sidearm) {
                #since some units have much better sidearms than spears, check if the troop needs an upgrade
                UpgradeSpear ([ref]$log) $spear $sidearm
                $log += "`t$($sidearm.id)"

                # TODO
                # ReplaceSidearm $sidearm
                $equipmentSet.RemoveChild($sidearm) | Out-Null
                $log += "`t$($sidearm.id)"
                $Script:modified = $true
            }
            Write-Output $log >> $logTarget
        }
    }
}

# Save pieces in new file
SaveXml $xml_spnpccharacters "generated/$fileName.xml"

Write-Output "Done"