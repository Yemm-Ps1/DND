Set-Location "D:\DnD\PND"
Clear-Host
Import-Module .\src\Write-Banner.ps1
Import-Module .\src\Classes.ps1
Import-Module .\src\Functions.ps1



Write-Banner "DUNGEONS" -ForegroundColor Red
Write-Banner "      +" -ForegroundColor Red
Write-Banner "        DRAGONS" -ForegroundColor Red
$host.ui.RawUI.WindowTitle = "Dungeons & Dragons"

Start-DND
$Whiskers.HP += 2*$Players.level[0]
$Svenn.HP += 1*$Players.level[0]

# WEIGHT AND STUFF

#"$($arnac.STR.Value * 15)lbs" 
#$arnac.gold / 50 gold = 1 pound



    <#$rolls=@()
    For($i = 0; $i -lt $dice; $i++){
        $rolls += Get-Random -Minimum 1 -Maximum ($value+1)
        Write-Host "Roll $($i+1):"
        Write-Host $rolls[-1]
    }
    $total = 0
    ForEach($rolled in $rolls){
        [int]$total += [int]$rolled
    }#>
<#
Function Roll {
    [Alias("!r")]
    Param($roll)
    [int]$dice = (($roll.Split('d')).split('-')).split('+')[0]
    [int]$value = (($roll.Split('d')).split('-')).split('+')[1]
    [int]$add = (($roll.Split('d')).split('-')).split('+')[2]
    [int]$minus = (($roll.Split('d')).split('-')).split('+')[3]
    $rolls =@()

    For($i = 0; $i -lt $dice; $i++){
        $rolls += Get-Random -Minimum 1 -Maximum ($value+1)
        Write-Host "Roll $($i+1):"
        Write-Host $rolls[-1]
    }
    $total = 0
    ForEach($rolled in $rolls){
        [int]$total += [int]$rolled
    }
    If($roll.Contains('-')){
        Write-Host "Rolled: $total - $minus `nTotal is: $($total-$minus)"
        Return $total+$minus
    }Else{
        Write-Host "Rolled: $total + $add `nTotal is: $($total+$add)"
        Return $total+$add
    }
    
}

#foreach($player in $players){$player.level += 1}
#>


#Function Get-Modifier{
#    [Alias('mod')]  
#    Param($value)
#    [math]::Floor(($value/2)-5)
#}

#
#
#while($true){Start-DnD;$Players | select Charactername, HP, AC;Start-Sleep 5;cls}
#$S = {[math]::Round((($this / 2)-5), 2)}
#[int] | Add-Member -MemberType ScriptMethod -Value $s -Name Mod
#$bob = New-Player -PlayerName Yemm -CharacterName Bob -Level 5 -Gold 1000 -HitDie 10 -AC 20 -STR 20 -DEX 8 -CON 16 -INT 10 -WIS 12 -CHA 14
#$Woodroe    =   [Player]::new("Glen", "Woodroe Blue-Bark", 5, "1000", "8", 16, 12, 17, 13, 8, 15, 10);
#$Varis      =   [Player]::new("Joe", "Varis Quinbiin", 5, "1000", "8", 17, 8, 16, 12, 14, 10, 17);
#$Arnac      =   [Player]::new("Matt", "Arnac Rockfist", 5, "1000", "12", 17, 18, 13, 16, 12, 10, 8);
#$Whiskers   =   [Player]::new("Danny", "Whiskers", 5, "1000", "8", 19, 8, 20, 10, 13, 12, 15);

#$Players = @($Woodroe, $Varis, $Arnac, $Whiskers)
