##############################################################################
#
# Line Length Check for Git pre-commit hook for Windows PowerShell
#
# Author: Ryan Janzen <rpwjanzen@gmail.com>
#
###############################################################################

### INSTRUCTIONS ###

# Place the code to file "pre-commit" (no extension) and add it to the one of 
# the following locations:
# 1) Repository hooks folder - C:\Path\To\Repository\.git\hooks
# 2) User profile template   - C:\Users\<USER>\.git\templates\hooks 
# 3) Global shared templates - C:\Program Files (x86)\Git\share\git-core\templates\hooks
# 
# The hooks from user profile or from shared templates are copied from there
# each time you create or clone new repository.

### FUNCTIONS ###

function line_length_check {
    param([int]$lineno, [string]$lineText)

    if ($lineText.StartsWith("#"))
    {
        return;
    }
    elseif ($lineno -eq 0 -and $lineText.Length -eq 0)
    {
        Write-Output "Line 1 cannot be empty"
        exit 1;
    }
    elseif ($lineno -eq 0 -and $lineText.Length -gt 50)
    {
        Write-Output "Summary must be less than 51 characters"
        Write-Output $lineText
        Write-Output "                                                  ^"
        exit 1;
    }
    elseif ($lineno -eq 1 -and -not $lineText.Length -eq 0)
    {
        Write-Output $lineText
        Write-Output "Line 2 must be empty"
        exit 1;
    }
    elseif ($lineText.Length -gt 72)
    {
        Write-Output "Line " + ($lineno + 1) + " must be less than 73 characters"
        Write-Output $lineText
        Write-Output "                                                                        ^"
        exit 1;
    }
}

function check_verb_tense {
    param([int]$lineno, [string]$lineText)
    $prohibitedWords = @("Added", "Adds", "Removed", "Removes", "Fixes", "Fixed", "Updated", "Updates");
    foreach($prohibitedWord in $prohibitedWords)
    {
        $lineWords = $lineText.Split(' ');
        foreach($lineWord in $lineWords)
        {
            if ($lineWord.ToUpperInvariant().Equals($prohibitedWord.ToUpper()))
            {
                Write-Output $word + " should be in the imperative tense"
                Write-Output $lineno + " " + $lineText
                exit 1;
            }
        }
    }
}

function check_lines {
    param([string]$commitPath)
    $lineno = 0
    $contents = Get-Content -Path $commitPath
    foreach ($lineText in $contents)
    {
        line_length_check -lineno $lineno -lineText $lineText
        check_verb_tense -lineno $lineno -lineText $lineText
        $lineno++;
    }
}

### MAIN ###
$commitPath = $args[0]
check_lines -commitPath $commitPath