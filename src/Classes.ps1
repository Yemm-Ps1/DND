class stat{
    [int]$Value;
    [int]$Mod;
    stat([int]$value){
        [int]$this.Value = $value
        [int]$this.Mod = [math]::Floor($value/2)-5
    }
    [string]ToString(){
        return [string]$this.Value
    }
    [int]GetMod(){
        return [int][math]::Floor(($this.Value/2)-5)
    }

}
<#
class proficiencies {
    Acrobatics (Dex)								
    Animal Handling (Wis)								
    Arcana (Int)								
    Athletics (Str)								
    Deception (Cha)								
    History (Int)								
    Insight (Wis)								
    Intimidation (Cha)								
    Investigation (Int)								
    Medicine (Wis)								
    Nature (Int)								
    Perception (Wis)								
    Performance (Cha)								
    Persuasion (Cha)								
    Religion (Int)								
    Sleight of Hand (Dex)								
    Stealth (Dex)								
    Survival (Wis)								
}
#>
class character{
    [string]$Name;
    [int]$Level;
    [int]$Gold;
    [int]$HP;
    [int]$AC;
    [stat]$STR;
    [stat]$DEX;
    [stat]$CON;
    [stat]$INT;
    [stat]$WIS;
    [stat]$CHA;
    hidden [string]$Colour;
    hidden [string]$Tag;
    hidden [string]$Symbol;
    hidden [int]$HitDie;
    hidden [int]$Initiative;
    hidden [int]$proficiencyBonus;
    [int]GetHP(){
        [int]$perLevel = ($this.HitDie/2)+1
        [int]$withCon = $perLevel + $this.CON.GetMod()
        [int]$total = ($withCon * $this.Level) + ($this.HitDie - $perLevel)
        return [int]$Total
    }
    [void]WriteName(){
        Write-Host $this.Name -ForegroundColor $this.Colour -NoNewline
    }
    [void]WriteName([bool]$symbol){
        Write-Host "$($this.symbol) $($this.Name)" -ForegroundColor $this.Colour -NoNewline
    }
    #overload
    [void]WriteNameList(){
        Write-Host "$($this.Symbol) $($this.Name)" -ForegroundColor $this.Colour
    }
    
    [void]Turn(){
        Write-Host "It is " -NoNewline;$this.WriteName(); Write-Host "'s turn"
        $this.DeclareHP()
        $global:reference = $this
        Function Global:Prompt {
            Write-Host "$($global:reference.Name)>" -NoNewline -ForegroundColor $global:reference.Colour
            return " "
        }
        #[ValidateSet("Attack", "Roll")]Read-Host "What will $($this.WriteName($false)) do?"

        $global:whoseturnisitanyway = $this
    }
    [void]Wait(){
        Start-Sleep -Milliseconds 750
    }

    [void]DeclareHP(){
        Write-Host "$($this.WriteName($true)) has taken $($this.hp) damage!"
    }
}

class turn {
    $character
    $input
    [void]Attack(){

    }
}



class containers{

}

class items{

}

class nonPlayer : character {
    nonPlayer([string]$Name,
    [int]$Level,
    [int]$Gold,
    [int]$AC,
    [int]$HitDie,
    [stat]$STR,
    [stat]$DEX,
    [stat]$CON,
    [stat]$INT,
    [stat]$WIS,
    [stat]$CHA){
        $this.Name = $Name;
        $this.Level = $Level;
        $this.Gold = $Gold;
        $this.AC = $AC;
        $this.HitDie = $HitDie;
        $this.STR = $STR;
        $this.DEX = $DEX;
        $this.CON = $CON;
        $this.INT = $INT;
        $this.WIS = $WIS;
        $this.CHA = $CHA;
        $this.Colour = 'Yellow'
        $this.Symbol = '~'
        $this.Tag = 'Neutral'
    }

}

class enemy : character {
    
    enemy([string]$Name,
    [int]$Level,
    [int]$Gold,
    [int]$AC,
    [int]$HitDie,
    [stat]$STR,
    [stat]$DEX,
    [stat]$CON,
    [stat]$INT,
    [stat]$WIS,
    [stat]$CHA){
        $this.Name = $Name;
        $this.Level = $Level;
        $this.Gold = $Gold;
        $this.AC = $AC;
        $this.HitDie = $HitDie;
        $this.STR = $STR;
        $this.DEX = $DEX;
        $this.CON = $CON;
        $this.INT = $INT;
        $this.WIS = $WIS;
        $this.CHA = $CHA;
        $this.Colour = 'Red';
        $this.Symbol = '!';
        $this.Tag = 'Enemy';
    }
    [void]Hit([int] $Amount){
        $this.HP = $this.HP + $Amount;
            Write-Host "$($this.Name) takes $($this.HP) damage!" -ForegroundColor YELLOW
    }
}

class player : character {
    # Properties: All the data that goes into a Player Object
    hidden [string]$PlayerName;
    hidden [int]$Rests;
    Player(
        [string]$PlayerName,
        [string]$Name,
        [int]$Level,
        [int]$HP,
        [int]$Gold,
        [int]$HitDie,
        [int]$AC,
        [stat]$STR,
        [stat]$DEX,
        [stat]$CON,
        [stat]$INT,
        [stat]$WIS,
        [stat]$CHA,
        [string]$Colour){
            $this.PlayerName = $PlayerName;
            $this.Name = $Name;
            $this.Level = $Level;
            $this.HP = $HP;
            $this.Gold = $Gold;
            $this.HitDie = $HitDie;
            $this.AC = $AC;
            $this.STR = $STR;
            $this.DEX = $DEX;
            $this.CON = $CON;
            $this.INT = $INT;
            $this.WIS = $WIS;
            $this.CHA = $CHA;
            $this.Colour = $Colour;
            $this.Symbol = '&';
            $this.Tag = 'Player';
            $this.Rests = $this.Level;
            $this.proficiencyBonus = [math]::ceiling($this.level/4)+1
    }

    [void]Hit([int] $Amount){
        $this.HP = $this.HP - $Amount;
        Write-Host $this.WriteName() "was hit and has taken " -NoNewline; Write-Host $amount -ForegroundColor Red -NoNewline; Write-Host " damage!"
        If($this.HP -lt 1){
            Write-Host "$($this.WriteName($true)) has been knocked unconscious!" -ForegroundColor YELLOW
            If($this.HP -lt -$this.GetHP()){
                $this.WriteName()
                Write-Host " is fucking dead mate."
                return
            }
            $this.HP = 0
            Write-Host $this.WriteName() "is now at " -NoNewline;$this.WriteHP(); Write-Host " health!"
            return
        }
        Write-Host $this.WriteName() "is now at " -NoNewline;$this.WriteHP(); Write-Host " health!"
    }
    [void]WriteHP(){
        Write-Host $this.HP -ForegroundColor Red -NoNewline
    }
    [int]GetRests() {
        return $this.Rests
    }
    [int]GetRests($int) {
        $this.Rests -= $int
        return $this.Rests
    }
    [void]LongRest(){
        $this.HP = $this.GetHP()
        $this.Rests = $this.Level
        Write-Host "$($this.WriteName($true)) has taken a long rest and is now at " -NoNewline; $($this.WriteHP()); Write-Host "hp" -ForegroundColor Red
    }
    [void]ShortRest(){
        If($this.GetRests() -eq 0){
            Write-Host $this.WriteName()"has no rests left!"
            return
        }
        $this.WriteName($true)
        Write-Host " rolls for a Short Rest"
        $this.Heal($(!r 1d"$($this.HitDie)+$($this.Con.Mod)" -return))
        $this.GetRests(1)
        $this.Wait()
    }
    [void]Heal([int]$value){
        $this.hp += $value
        If($this.hp -gt $this.GetHP()){
            $this.hp = $this.GetHP()
        }
        Write-Host "$($this.WriteName()) heals for " -NoNewline; Write-Host "$value" -ForegroundColor Green -NoNewline; Write-Host " and is now at " -NoNewline; $this.WriteHP();Write-Host " health"
        Write-Host ""
    }
    [void]DeclareHP(){
        Write-Host "$($this.WriteName($true)) has $($this.hp)hp!"
    }
}

