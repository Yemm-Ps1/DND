
Import-Module .\src\Classes.ps1
Import-Module .\src\Functions.ps1
Import-Module .\src\AbilityUtil.ps1
Import-Module .\src\RollUtil.ps1

$CHARACTER_RONNIE = [player]::new("Ronnie McTest", "Ronnie", 10, 90, 1000, 10, 19, 15, 13, 12, 10, 8, 8, "Blue", {})
# $CHARACTER_BOB = [player]::new("Bob McTest", "Bob", 7, 90, 1000, 10, 19, 15, 13, 12, 10, 8, 8, "Blue", {})

$UNBEATABLE_DC = 1000
$POWERLESS_DC = -1000

# Describe "Tests Ability Saving Throws for DcVsMod parameter sets" {
#     $ABILITY_SAVE_CASES = @(
#             @{Ability_ModAdvModifier=-2}
#             @{AdvModifier=-1}
#             @{AdvModifier=0}
#             @{AdvModifier=1}
#             @{AdvModifier=2}
#             @{AdvModifier=0}
#         )
# }

Describe "Tests Ability Saving Throws for DcVsCharacter parameter sets" {
    $ABILITY_SAVE_CASES = @(
            @{AbilityType = [AbilityTypes]::Str; AdvModifier=-2}
            @{AbilityType = [AbilityTypes]::Dex; AdvModifier=-1}
            @{AbilityType = [AbilityTypes]::Con; AdvModifier=0}
            @{AbilityType = [AbilityTypes]::Int; AdvModifier=1}
            @{AbilityType = [AbilityTypes]::Wis; AdvModifier=2}
            @{AbilityType = [AbilityTypes]::Cha; AdvModifier=0}
        )
    
    It "Tests MakeAbilitySaveThrow - with DcVsCharacter IGNORING ADVANTAGE MOD against an UNBEATABLE DC with type <AbilityType> and roll modifier <AdvModifier> - should always FAIL" -TestCases $ABILITY_SAVE_CASES {
            param([AbilityTypes] $AbilityType, [int] $AdvModifier)
            $test_result = MakeAbilitySaveThrow $AbilityType $UNBEATABLE_DC $CHARACTER_RONNIE -Return
            $test_result | Should -Be $false
    }
    It "Tests MakeAbilitySaveThrow - with DcVsCharacter against an UNBEATABLE DC with type <AbilityType> and roll modifier <AdvModifier> - should always FAIL" -TestCases $ABILITY_SAVE_CASES {
        param([AbilityTypes] $AbilityType, [int] $AdvModifier)
        $test_result = MakeAbilitySaveThrow $AbilityType $UNBEATABLE_DC $CHARACTER_RONNIE -advantage_mod $AdvModifier -Return
        $test_result | Should -Be $false
    }

    It "Tests MakeAbilitySaveThrow - with DcVsCharacter against an POWERLESS DC with type <AbilityType> and roll modifier <AdvModifier> - should always SUCCEED" -TestCases $ABILITY_SAVE_CASES {
        param([AbilityTypes] $AbilityType, [int] $AdvModifier)
        $test_result = MakeAbilitySaveThrow $AbilityType $POWERLESS_DC $CHARACTER_RONNIE -advantage_mod $AdvModifier -Return
        $test_result | Should -Be $true
    }

    It "Tests MakeAbilitySaveThrow - with out of range advantage modifiers - should throw exception" {
        {MakeAbilitySaveThrow ([AbilityTypes]::Str) 0 $CHARACTER_RONNIE -advantage_mod -3 -Return} | Should -Throw
        { MakeAbilitySaveThrow [AbilityTypes]::Str 0 $CHARACTER_RONNIE -advantage_mod 3 -Return} | Should -Throw
        # $test_result | Should -Be $true
    }
    It "Tests GetProficiencyBonus - with level <Level> character - should have value <ExpectedProficiencyBonus>" -TestCases @(
        @{Level = 1; ExpectedProficiencyBonus = 2}
        @{Level = 2; ExpectedProficiencyBonus = 2}
        @{Level = 3; ExpectedProficiencyBonus = 2}
        @{Level = 4; ExpectedProficiencyBonus = 2}
        @{Level = 5; ExpectedProficiencyBonus = 3}
        @{Level = 7; ExpectedProficiencyBonus = 3}
        @{Level = 10; ExpectedProficiencyBonus = 4}
        @{Level = 13; ExpectedProficiencyBonus = 5}
        @{Level = 20; ExpectedProficiencyBonus = 6}
    ){
        param([int] $Level, [int] $ExpectedProficiencyBonus)
        $test_result = GetProficiencyBonus $level
        $test_result | Should -Be $ExpectedProficiencyBonus    
    }

}

Describe "Tests Skill Checks" {
    Write-Host ">>>" "Doing skill checks"
    It "Tests MakeSkillCheck - against an UNBEATABLE DC with mod <AbilityMod> on prof-type <ProfType> and advantage mod <AdvantageMod> - should always fail " -TestCases @(
        @{DC = $UNBEATABLE_DC; AbilityMod = 0; ProfType = [ProficiencyTypes]::Normal; AdvantageMod = 0}
    ) {
            param([int] $DC, [int] $AbilityMod, [ProficiencyTypes] $ProfType, [int] $AdvantageMod)
            Write-Host $DC $AbilityMod $ProfType $AdvantageMod
            $test_result = MakeSkillCheck $DC $AbilityMod $ProfType $AdvantageMod Blue -return
            $test_result | Should -Be $false
    }

}


Describe "Tests Misc Functions" {
    

}