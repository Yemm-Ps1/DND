

Function Prompt {
    Write-Host ("DND>") -NoNewline -ForegroundColor Cyan
    return " "
}

Function Aids{
    foreach($player in $players){if($player.name -ne "Svenn Irontallow"){$player.hp += 5}}
}
Function Start-DND {
    Param()
    Get-Players
    Write-Host "" -ForegroundColor DarkYellow
    #Write-Host ""

}

Function RandomItem {
    $randomItems = Get-Content "D:\DnD\PND\RandomItems.txt"
    $roll = (!r 1d100 -return)
    $randomItems | Select-String -Pattern "^$roll."
}

Function ShipDamage {
    !r 1d1500+500
}

Function New-Save{
    [Alias("Rest")]
    Param(
    $Mod,
    $Limit
    )
    foreach($player in $players){
        $num = (!r 1d20+$($player."$Mod".mod) -return)
        if($num -lt $Limit){
            "$($player.writename()) failed their save!"
        }
        else{
            "$($player.WriteName()) success"
        }
    }
}
Function Start-Rest {
    [Alias("Rest")]
    Param(
        [ValidateSet("Long", "Short")]$Length="Short",
        $Player,
        [int]$Rests=1
    )
    Write-Host ""
    Switch($Length){
        "Long"{
            if($Player){
                $Player.LongRest()
            }else{
                $Players.LongRest()
                $Whiskers.HP += 2*$Players.level[0]
                $Svenn.HP += 1*$Players.level[0]
            }
        }
        "Short"{
            if($Player){
                $Player.ShortRest()
            }else{
                $Players.ShortRest()
                }
            }
    }
}

Function Get-PlayersHealth {
    [Alias("Health")]
    Param()
    ForEach($Player in $Players){
        Write-Host $Player.WriteName($true) "$($Player.HP)/$($Player.GetHP())"
    }
}

Function Woodroe {
   ($Woodroe | out-string).split("`n") -match '\S'
}


Function New-Enemy {
    Param(
        $Name,
        $Level,
        $Gold,
        $AC,
        $HitDie,
        $STR,
        $DEX,
        $CON,
        $INT,
        $WIS,
        $CHA
    )
    $Enemy = [enemy]::new($Name, $Level, $Gold, $AC, $HitDie, $STR, $DEX, $CON, $INT, $WIS, $CHA)
    return $Enemy
}
Function Get-Enemy {
    Param(
        [ValidateSet("Generic")]$Type,
        $Name
    )
    If($Type -eq "Generic"){
        $Level = $Woodroe.Level
        $Gold = Get-Random -Minimum 50 -Maximum 1001
        $AC = Get-Random -Minimum 8 -Maximum 19
        $HitDie = Get-Random -Minimum 6 -Maximum 15
        $STR = Get-Random -Minimum 8 -Maximum 21
        $DEX = Get-Random -Minimum 8 -Maximum 21
        $CON = Get-Random -Minimum 8 -Maximum 21
        $INT = Get-Random -Minimum 8 -Maximum 21
        $WIS = Get-Random -Minimum 8 -Maximum 21
        $CHA = Get-Random -Minimum 8 -Maximum 21
        return New-Enemy -Name $Name -Level $Level -Gold $Gold -AC $AC -HitDie $HitDie -STR $STR -DEX $DEX -CON $CON -INT $INT -WIS $WIS -CHA $CHA
    }
}

Function New-Player{
    Param(
        $PlayerName,
        $Name,
        $Level,
        $HP,
        $Gold,
        $HitDie,
        $AC,
        $STR,
        $DEX,
        $CON,
        $INT,
        $WIS,
        $CHA,
        $Colour
    )
    $Player = [player]::new($PlayerName, $Name, $Level, $HP, $Gold, $HitDie, $AC, $STR, $DEX, $CON, $INT, $WIS, $CHA, $Colour)
    return $Player
}
Function New-Player{
    Param(
        [Parameter(ParameterSetName="Import")]
        $importedXML,
        [Parameter(ParameterSetName="New")]
        $PlayerName,
        $Name,
        $Level,
        $HP,
        $Gold,
        $HitDie,
        $AC,
        $STR,
        $DEX,
        $CON,
        $INT,
        $WIS,
        $CHA,
        $Colour
    )
    If($PlayerName){
        $Player = [player]::new($PlayerName, $Name, $Level, $HP, $Gold, $HitDie, $AC, $STR, $DEX, $CON, $INT, $WIS, $CHA, $Colour)
    }else{
        $Player = [player]::new($importedXML.PlayerName, $importedXML.Name, $importedXML.Level, $importedXML.HP, $importedXML.Gold, $importedXML.HitDie, $importedXML.AC, $importedXML.STR.Value, $importedXML.DEX.Value, $importedXML.CON.Value, $importedXML.INT.Value, $importedXML.WIS.Value, $importedXML.CHA.Value, $importedXML.Colour)
    }
    return $Player
}


Function Get-Player{
    Param([ValidateSet('Varis Quinbiin', 'Arnac Rockfist', 'Woodroe Blue-Bark', 'Whiskers', 'Alfonzo', 'Spindles', 'Rum', 'Jin', 'Svenn Irontallow', 'Jamuel Saxon')]$Player)
    # TODO - IMPORT PLAYERS BETTER
    $import = Import-Clixml ".\Players\$Player.xml"
    New-Player -importedXML $import
    #New-Player -PlayerName $import.PlayerName -Name $import.Name -Level $import.Level -HP $import.HP -Gold $import.Gold -HitDie $import.HitDie -AC $import.AC -STR $import.STR.value -DEX $import.DEX.value -CON $import.CON.value -INT $import.INT.value -WIS $import.WIS.value -CHA $import.CHA.value -Colour $import.Colour
}

# TODO Container Class for everything
Function Get-Players{
    [Alias("Load")]
    $Global:Varis = Get-Player "Varis Quinbiin"
    $Global:Arnac = Get-Player "Arnac Rockfist"
    $Global:Woodroe = Get-Player "Woodroe Blue-Bark"
    $Global:Whiskers = Get-Player "Whiskers"
    $Global:Svenn = Get-Player "Svenn Irontallow"
    $Global:Jamuel = Get-Player "Jamuel Saxon"
    $Global:Alfonzo = Get-Player "Alfonzo"
    $Global:Spindles = Get-Player "Spindles"
    $Global:Jin = Get-Player "Jin"
    $Global:Rum = Get-Player "Rum"

    $Global:Players = @($Woodroe, $Varis, $Arnac, $Whiskers, $Svenn, $Jamuel)
}
Function Save-Player{
    Param($Player)
    $Player | Export-Clixml ".\Players\$($Player.Name).xml"

}
Function Save-Players{
    ForEach($Player in $Players){Save-Player $Player}
}

Function Healing-Potion {
    Param($Player)
    $Player.Heal($(!r 1d12+$($Player.Con.Mod) -return))
}

# joes bardic short rest ting
#foreach($player in $players){$player.heal($(!r 1d6 -return))}
Function New-Initiative {
    [Alias("Init")]
    Param($enemies = $null)
    Write-Host ""
    ForEach($player in $players){

        Write-Host "$($Player.WriteName($true)) rolls for initiative!" 
        [int]$Player.Initiative = (!r 1d20+$($Player.DEX.GetMod()) -Return)
        ""
        $Player.Wait()
    }
    ForEach($enemy in $enemies){

        Write-Host "$($enemy.WriteName($true)) rolls for initiative!"
        [int]$enemy.Initiative = (!r 1d20+$($enemy.DEX.GetMod()) -Return)
        ""
        $Enemy.Wait()
    }
    Get-Initiative -Enemies $enemies
}

Function Get-Initiative {
    Param(
        $enemies
    )
    $sorted = ($players + $enemies) | Sort-Object Initiative -Descending
    ForEach($sort in $sorted){
        $sort.WriteName($true) + ": " + $sort.Initiative
    }
    
}



#combat $enemy $enemy2
Function Start-Combat{
    [Alias("Combat")]
    Param(

    )
    if(!$args){Write-Host "No enemies selected!"; return}
    Write-Host "Starting Combat With:"
    $args.WriteNameList()
    New-Initiative $args
}