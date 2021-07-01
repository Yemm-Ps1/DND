
Import-Module .\src\Classes.ps1
Import-Module .\src\Functions.ps1
Import-Module .\src\AbilityUtil.ps1
Import-Module .\src\RollUtil.ps1

$TEST_CHARACTER = [player]::new("Test Man", "Test Man", 10, 101, 0, 6, 16, 15, 14, 12, 11, 10, 8, "Blue")
$ALL_CASES = @(
        @{AbilityType = [AbilityTypes]::Str; AdvModifier=-2}
        @{AbilityType = [AbilityTypes]::Dex; AdvModifier=-1}
        @{AbilityType = [AbilityTypes]::Con; AdvModifier=0}
        @{AbilityType = [AbilityTypes]::Int; AdvModifier=1}
        @{AbilityType = [AbilityTypes]::Wis; AdvModifier=2}
        @{AbilityType = [AbilityTypes]::Cha; AdvModifier=0}
    )
$UNBEATABLE_DC = 1000
$POWERLESS_DC = -1000


Describe "Ability Saving Throw Tests " {
    It "Tests MakeAbilitySaveThrow - against an UNBEATABLE DC with type <AbilityType> and roll modifier <AdvModifier> - should always FAIL" -TestCases $ALL_CASES {
    param([AbilityTypes] $AbilityType, [int] $AdvModifier)
    $test_result = MakeAbilitySaveThrow $AbilityType $UNBEATABLE_DC $TEST_CHARACTER $AdvModifier -Return
    $test_result | Should -Be $false
    }

    It "Tests MakeAbilitySaveThrow - against an POWERLESS DC with type <AbilityType> and roll modifier <AdvModifier> - should always SUCCEED" -TestCases $ALL_CASES {
        param([AbilityTypes] $AbilityType, [int] $AdvModifier)
        $test_result = MakeAbilitySaveThrow $AbilityType $POWERLESS_DC $TEST_CHARACTER $AdvModifier -Return
        $test_result | Should -Be $true
    }

    It "Tests MakeAbilitySaveThrow - with out of range advantage modifiers - should throw exception" {
        {MakeAbilitySaveThrow ([AbilityTypes]::Str) 0 $TEST_CHARACTER -3 -Return} | Should -Throw
        { MakeAbilitySaveThrow [AbilityTypes]::Str 0 $TEST_CHARACTER 3 -Return} | Should -Throw
        # $test_result | Should -Be $true
    }

}