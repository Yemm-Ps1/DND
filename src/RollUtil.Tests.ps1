Clear-Host
Import-Module .\src\RollUtil.ps1

$ROLL_SAMPLE_SIZE = 1
$JUST_MODIFIER_TEST_CASES = @(
    @{Modifier = 0; ExpectedMin = 1; ExpectedMax = 20} 
    @{Modifier = 5; ExpectedMin = 6; ExpectedMax = 25} 
    @{Modifier = -3; ExpectedMin = -2; ExpectedMax = 17} 
)
$MIXED_DICE_TEST_CASES = @(
    @{DiceRoll = "1d6"; ExpectedMin = 1; ExpectedMax = 6}
    @{DiceRoll = "1d20"; ExpectedMin = 1; ExpectedMax = 20} 
    @{DiceRoll = "1d8+3"; ExpectedMin = 4; ExpectedMax = 11} 
    @{DiceRoll = "1d20+5"; ExpectedMin = 6; ExpectedMax = 25} 
    @{DiceRoll = "1d12-5"; ExpectedMin = -4; ExpectedMax = 7} 
    @{DiceRoll = "1d20-3"; ExpectedMin = -2; ExpectedMax = 17} 
)

Describe "Roll Tests " {
    It "Tests Regular Rolls - <DiceRoll>- should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $MIXED_DICE_TEST_CASES {
        param([string] $DiceRoll, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = Roll $DiceRoll -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        }
    }

    It "Tests GetMultiple Rolls - with modifier <Modifier> for MAX value - should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $JUST_MODIFIER_TEST_CASES {
        param([string] $Modifier, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = RollMultiple 3 $Modifier $true -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        }
    }
    
    It "Tests GetMultiple Rolls - with modifier <Modifier> for MIN value - should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $JUST_MODIFIER_TEST_CASES {
        param([string] $Modifier, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = RollMultiple 3 $Modifier $false -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        }
    }
    
    It "Tests Advantage Rolls - with modifier <Modifier>- should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $JUST_MODIFIER_TEST_CASES {
        param([int] $Modifier, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = RollAdvantage $Modifier -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        } 
    }
    
    It "Tests Super-Advantage Rolls - with modifier <Modifier>- should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $JUST_MODIFIER_TEST_CASES {
        param([int] $Modifier, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = RollSuperAdvantage $Modifier -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        } 
    }

    It "Tests Disdvantage Rolls - with modifier <Modifier> - should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $JUST_MODIFIER_TEST_CASES {
        param([int] $Modifier, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = RollDisadvantage $Modifier -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        } 
    }

    It "Tests Super-Disdvantage Rolls - with modifier <Modifier> - should always fall in range (<ExpectedMin>, <ExpectedMax>)" -TestCases $JUST_MODIFIER_TEST_CASES {
        param([int] $Modifier, [int] $ExpectedMin, [int] $ExpectedMax)
        for ($i=0; $i -le $ROLL_SAMPLE_SIZE; $i++) {
            $roll_result = RollSuperDisadvantage $Modifier -Return
            $roll_result | Should -BeGreaterOrEqual $ExpectedMin
            $roll_result | Should -BeLessOrEqual $ExpectedMax
        } 
    }

}