Set-Location "D:\DnD\PND"
Clear-Host
Import-Module .\src\Write-Banner.ps1
Write-Banner "DUNGEONS" -ForegroundColor Red
Write-Banner "      +" -ForegroundColor Red
Write-Banner "        DRAGONS" -ForegroundColor Red


Function Prompt {
    Write-Host ("DND>") -NoNewline -ForegroundColor Cyan
    return " "
}

Function Roll {
    [Alias("!r")]
    Param($roll)
    [int]$dice = ($roll.Split('d')).split('+')[0]
    [int]$value = ($roll.Split('d')).split('+')[1]
    [int]$add = ($roll.Split('d')).split('+')[2]
    $rolls =@()
    For($i = 0; $i -lt $dice; $i++){
        $rolls += Get-Random -Minimum 1 -Maximum ($value+1)
        "Roll $($i+1):"
        $rolls[-1]
    }
    $total = 0
    ForEach($rolled in $rolls){
        [int]$total += [int]$rolled
    }
    Write-Host "You rolled $total + $add `nTotal is: $($total+$add)"
}

$PlayerClass = New-Object psobject -Property @{
    PName = $null
    CName = $null
    Level = $null
    HP = $null
    HitDie = $null
    AC = $null
    STR = $null
    DEX = $null
    CON = $null
    INT = $null
    WIS = $null
    CHA = $null
}


Function New-Player {
    param(
        $PName,
        $CName,
        $Level,
        $HP,
        $HitDie,
        $AC,
        $STR,
        $DEX,
        $CON,
        $INT,
        $WIS,
        $CHA
    )
    $Player = $PlayerClass.psobject.copy()
    $Player.PName = $PName
    $Player.CName = $CName
    $Player.Level = $Level
    $Player.HP = $HP
    $Player.HitDie = $HitDie
    $Player.AC = $AC
    $Player.STR = $STR
    $Player.DEX = $DEX
    $Player.CON = $CON
    $Player.INT = $INT
    $Player.WIS = $WIS
    $Player.CHA = $CHA
    $Player
}

Function Save-Player {
    Param(
    $Player
    )
    $Player | Export-Csv -NoTypeInformation -Path D:\DnD\PND\Players\$($Player.CName).csv
}


Player
[csv]Player


Function Load-Players {
    $Global:Varis = Import-Csv "D:\DnD\PND\Players\Varis Quinbiin.csv"
    $Global:Woodroe = Import-Csv "D:\DnD\PND\Players\Woodroe Blue-Bark.csv"
    $Global:Players = @(
    $Varis,
    $Woodroe
)

}



Function Get-Player {
    Param(
        $Player
    )
    $Player.CName
    "HP: " + $Player.HP
    "AC: " + $Player.AC

}

Load-Players

Function Get-Initiative {
    [Alias("Init")]
    Param()
    ForEach($Player in $Players){
        $Player.CName + " rolls for initiative"
        (!r 1d20+$($Player.DEX))
    }
}

#$Varis = New-Player -PName "Joe" -CName "Varis Quinbiin" -Level 5 -HP 33 -HitDie "d8" -AC 17 -STR 8 -DEX 16 -CON 12 -INT 14 -WIS 10 -CHA 17
