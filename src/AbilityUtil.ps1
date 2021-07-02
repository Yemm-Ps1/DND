
enum AbilityTypes {
    Str
    Dex
    Con
    Int
    Wis
    Cha
}

enum SkillTypes {
    Acrobatics
    Animal
    Handling
    Arcana
    Athletics
    Deception
    History
    Insight
    Intimidation
    Investigation
    Medicine
    Nature
    Perception
    Performance
    Persuasion
    Religion
    Sleight
    Stealth
    Survival							
}

class SkilledEntity {

}

# Function MakeAbilitySaveThrow {
#     Param(
#         [AbilityTypes] $ability_type,
#         [character] $attacker,
#         [player] $defender,
#         [ValidateRange(-2, 2)] [int] $advantage_mod = 0, # -2=Super-Disadvantage -1=Disadvantage 0=Normal 1=Advantage 2=Super-Disadvantage
#         [switch] $return
#     )
#     # $dc = $attacker.get_dc??
#     return MakeAbilitySaveThrow $ability_type $dc $advantage_mod -return
# } 
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parameter_sets?view=powershell-7.1


Function MakeAbilitySaveThrow {
    Param(
        [AbilityTypes] $ability_type,
        [int] $dc,
        [player] $defender,
        [ValidateRange(-2, 2)] [int] $advantage_mod = 0, # -2=Super-Disadvantage -1=Disadvantage 0=Normal 1=Advantage 2=Super-Disadvantage
        [switch] $return
    )

    [stat]$stat = $null
    switch ($ability_type){
        Str {
            $stat = $defender.STR
        }
        Dex {
            $stat = $defender.DEX
        }
        Con {
            $stat = $defender.CON
        }
        Int {
            $stat = $defender.INT
        }
        Wis {
            $stat = $defender.WIS
        }
        Cha {
            $stat = $defender.CHA
        }
    }
    $ability_mod = $stat.Mod
    if ($stat.IsSavingProficient) {
        $ability_mod += [math]::ceiling($defender.Level / 4) + 1
    }

    # works out the type of throw(super-disadvantage=-2, ..., super-advantage=2) and whether to use max or min of dice (max if >0)
    Write-Host ([int] $advantage_mod / 2) $ability_mod ($advantage_mod -ge 0)
    $saving_throw = RollMultiple ([math]::Abs($advantage_mod)+1) $ability_mod ($advantage_mod -ge 0)  -return 

    $was_passed = $saving_throw -ge $dc
    if ($was_passed) {
        WriteSavingThrowResult $defender " passed their saving throw against " $dc
    } else {
        WriteSavingThrowResult $defender " failed their saving throw against " $dc
    }

    if($return) {
        Return $was_passed
    }
}

function GetProficiencyBonus {
    Param([int] $character_level)
    return [math]::ceiling($character_level / 4) + 1
}

function WriteSavingThrowResult {
    param ([player] $defender, [string] $affix, [int] $dc)
    Write-Host $defender.Name -ForegroundColor $defender.Colour -NoNewline
    Write-Host $affix -NoNewline 
    Write-Host $dc -ForegroundColor Yellow -NoNewline
    Write-Host .
}

# $test_character = [player]::new("Test Man", "Test Man", 10, 101, 0, 6, 16, 15, 14, 12, 11, 10, 8, "Blue")

# $rtn_val = MakeAbilitySaveThrow ([AbilityTypes]::Str) 14 $test_character -2 -Return

# Write-Host "Value found: " $rtn_val
