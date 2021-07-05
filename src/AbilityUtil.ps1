
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

enum ProficiencyTypes {
    Normal
    Proficient
    Expertise
}

enum DifficultyClasses {
    VeryEasy
    Easy
    Medium
    Hard
    VeryHard
    NearImpossible
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
    # TODO Parameter Sets: DcVsMod, DcVsCharacter, CharacterVsMod, CharacterVsCharacter
    # TODO replace player with character
    [CmdletBinding(DefaultParameterSetName = 'DcVsMod')]
    Param(
        [Parameter(Mandatory = $true,
            ParameterSetName = 'DcVsCharacter',
            HelpMessage = 'Enter a raw integer dc vs a character object',
            Position = 0)]
        [AbilityTypes] $ability_type,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'DcVsMod',
            HelpMessage = 'Enter a raw integer dc vs a raw ability modifier',
            Position = 0)]
        [Parameter(Mandatory = $true, ParameterSetName = 'DcVsCharacter', Position=1)]
        [int] $dc,
        
        [Parameter(ParameterSetName = 'DcVsMod')]
        [int] $ability_mod = 0,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'DcVsCharacter', Position=2)]
        [player] $defender,
        
        [ValidateRange(-2, 2)] [int] $advantage_mod = 0, # -2=Super-Disadvantage -1=Disadvantage 0=Normal 1=Advantage 2=Super-Disadvantage
        [switch] $return
    )
    begin {
        if (!$dc) {
            # TODO add character retrieval of DC
        }
        # Retrives the ability mod for a defending character, if the character was passed instead of a raw ability mod
        if (!$ability_mod -and $defender) {
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
        }
    } process {
    
        # works out the type of throw(super-disadvantage=-2, ..., super-advantage=2) and whether to use max or min of dice (max if >0)
        $saving_throw = RollMultiple ([math]::Abs($advantage_mod)+1) $ability_mod ($advantage_mod -ge 0)  -return 
    
        $was_passed = $saving_throw -ge $dc
        WriteThrowResult $defender.colour $was_passed "saving throw" $dc
    
        if($return) {
            Return $was_passed
        }

    }
}

function MakeSkillCheck() {
    # TODO add parameter sets for using characters instead of numbers
    param(
        [int] $dc,
        [int] $ability_mod,
        [ProficiencyTypes] $prof_type,
        [ValidateRange(-2, 2)] [int] $advantage_mod = 0, # -2=Super-Disadvantage -1=Disadvantage 0=Normal 1=Advantage 2=Super-Disadvantage
        [System.ConsoleColor] $thrower_color,
        [switch] $return
    )
    $prof_mod = 0
    switch($prof_type) {
        Proficient {
            $prof_mod = 5
        } Expertise {
            $prof_mod = 10
        }
    }
    $add_modifier = $ability_mod + $prof_mod
    $saving_throw = RollMultiple ([math]::Abs($advantage_mod)+1) $add_modifier ($advantage_mod -ge 0)  -return 

    $was_passed = $saving_throw -ge $dc
    WriteThrowResult $thrower_color $was_passed "saving throw" $dc

    if($return) {
        Return $was_passed
    }
}


function GetProficiencyBonus {
    Param([int] $character_level)
    return [math]::ceiling($character_level / 4) + 1
}

function WriteThrowResult {
    param ([System.ConsoleColor] $thrower_color, [bool] $was_success, [string] $throw_lbl, [int] $dc)
    Write-Host $defender.Name -ForegroundColor Blue -NoNewline
    if($was_success) {
        Write-Host " saved their $throw_lbl against " -NoNewline 
    } else {
        Write-Host " failed their $throw_lbl against " -NoNewline 
    }
    Write-Host $dc -ForegroundColor Yellow -NoNewline
    Write-Host .
}

# $test_character = [player]::new("Test Man", "Test Man", 10, 101, 0, 6, 16, 15, 14, 12, 11, 10, 8, "Blue", {})
# $test_character.STR.IsSavingProficient = $true
# $rtn_val = MakeAbilitySaveThrow ([AbilityTypes]::Str) 14 $test_character -advantage_mod 1 -Return

# Write-Host "Value found: " $rtn_val
