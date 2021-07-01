Function Roll {
    [Alias("!r")]
    Param($roll = '1d20', [switch]$return, [switch]$no_print)
    $parsed = $roll -replace ("-", "+-") -split "[+d]+"
    $i = 0
    $toAdd = 0
    [int]$dice = $parsed[0]
    [int]$value = $parsed[1]
    If($parsed[2]){
        ($parsed[2..($parsed.Length-1)]) | ForEach-Object {$i += [int]$_}
        $toAdd = $i
    }
    $rolls=@()
    For($i = 0; $i -lt $dice; $i++){
        $rolls += Get-Random -Minimum 1 -Maximum ($value+1)
        Write-Host "Rolled:"$rolls[-1]
        $total = $total + $rolls[-1]
    }
    Write-Host "Total: "$total + $toAdd = "" -NoNewline
    Write-Host "$($total + $toAdd)" -ForegroundColor Yellow
    
    If($return){Return $total+$toAdd}
}

Function RollAdvantage{
    [Alias("!ra")]
    Param([int]$modifier, [switch]$return)
    $winner = RollMultiple 2 $modifier $true -return -no_print
    WriteRollMessage $winner "advantage" $modifier
    If($return){Return $winner}
}

Function RollDisadvantage{
    [Alias("!rd")]
    Param([int]$modifier, [switch]$return)
    $winner = RollMultiple 2 $modifier $false -return
    WriteRollMessage $winner "disadvantage" $modifier
    If($return){Return $winner}
}

Function RollSuperAdvantage{
    [Alias("!rsa")]
    Param([int]$modifier, [switch]$return)
    $winner = RollMultiple 3 $modifier $true -return
    WriteRollMessage $winner "super-advantage" $modifier
    If($return){Return $winner}
}

Function RollSuperDisadvantage{
    [Alias("!rsd")]
    Param([int]$modifier, [switch]$return)
    $winner = RollMultiple 3 $modifier $false -return
    WriteRollMessage $winner "super-disadvantage" $modifier
    If($return){Return $winner}
}

Function RollMultiple {
    Param([int] $num_of_dice, [int] $modifier, [bool] $is_max_dice, [switch] $return)
    $dice_rolls = @()
    for($i = 0; $i -lt $num_of_dice; $i++) {
        $nxt_roll = !r 1d20+$modifier -return -no_print
        $dice_rolls += $nxt_roll
    }
    if ($is_max_dice) {
        $winner = ($dice_rolls | Measure-Object -max).Maximum
    } else {
        $winner = ($dice_rolls | Measure-Object -min).Minimum
    }
    If($return){Return $winner}
}

Function WriteRollMessage {
    Param([int] $outcome, [string] $roll_type, [string] $modifier)
    # TODO FIX THIS SHIT

    Write-Host "Rolled " -NoNewline;
    Write-Host $outcome -ForegroundColor Red -NoNewline; 
    Write-Host " with $roll_type."
}