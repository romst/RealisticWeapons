$fileName = 'modified_crafting_pieces'
$logTarget = "$PSScriptRoot/generated/result_pieces.csv"

Remove-Item -path "$PSScriptRoot/generated/ModuleData/" -include *.xml -Recurse
Remove-Item -path "$PSScriptRoot/generated/" -include *.csv -Recurse

Write-Output "Item`tType`tThrust-damageType`tThrust-damageFactor`tThrust-damageFactorNew`tSwing-damageType`tSwing-damageFactor`tSwing-damageFactorNew" >> $logTarget

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
$xml_crafting = LoadXml("source_data/crafting_pieces.xml")

$xml_crafting.SelectNodes('//CraftingPiece') | ForEach-Object{
    # Create node for piece
    $craftingPiece = $_
    $log = "$($craftingPiece.id)`t$($craftingPiece.piece_type)"
    
    # Modify blade
    $bladeData = $craftingPiece.BladeData
    
    if ($bladeData) {
        $thrust = $bladeData.Thrust
        $swing = $bladeData.Swing
        
        if ($thrust -and $swing) {
            $log += "`t$($thrust.damage_type)`t$($thrust.damage_factor)"
            $thrust.damage_factor = [math]::Min([decimal]$thrust.damage_factor * 1.25, 6).ToString([System.Globalization.CultureInfo]::InvariantCulture)
            $log += "`t$($thrust.damage_factor)`t$($swing.damage_type)`t$($swing.damage_factor)`t$($swing.damage_factor)"
        } elseif ($thrust) {
            $log += "`t$($thrust.damage_type)`t$($thrust.damage_factor)"
            $thrust.damage_factor = [math]::Min([decimal]$thrust.damage_factor * 2, 6).ToString([System.Globalization.CultureInfo]::InvariantCulture)
            $log += "`t$($thrust.damage_factor)`t$($swing.damage_type)`t$($swing.damage_factor)`t$($swing.damage_factor)"
        } else {
            $log += "`t$($thrust.damage_type)`t$($thrust.damage_factor)`t$($thrust.damage_factor)`t$($swing.damage_type)`t$($swing.damage_factor)`t$($swing.damage_factor)"
            $xml_crafting.CraftingPieces.RemoveChild($craftingPiece) | Out-Null
        }

        Write-Output $log >> $logTarget
    }
}

# Save pieces in new file
SaveXml $xml_crafting "generated/ModuleData/$fileName.xml"

Write-Output "Done"