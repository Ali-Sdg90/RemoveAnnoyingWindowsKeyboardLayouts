$credit = @"
=====================================================================
By Behzad Seyfi 2025
You can find me at github.com/BSeyfi
Made with love to make the world a little simpler and more beautiful.

repo: https://github.com/BSeyfi/RemoveAnnoyingWindowsKeyboardLayouts
=====================================================================
"@
echo $credit

$LanguageTagToRemove = "fa"
# Only keep the 0429:00050429 layout
$KeyboardsToKeep = @("0429:00050429")
$KeyboardsToRemove = @("0429:00000429", "0429:B0020429")

Set-ExecutionPolicy Bypass -Scope Process -Force

# First, add the annoying layouts
$LanguageList = Get-WinUserLanguageList
foreach ($kb in $KeyboardsToRemove) {
    $LanguageList[0].InputMethodTips.Add($kb) 
    Write-Host "Added: $kb"
}

Set-WinUserLanguageList $LanguageList -Force

# Next, remove the annoying layouts, keeping only 0429:00050429
$LanguageList = Get-WinUserLanguageList

for ($i = 0; $i -lt $LanguageList.Count; $i++) {
    if ($LanguageList[$i].LanguageTag -eq $LanguageTagToRemove) {
        $LanguageIndex = $i
        break
    }
}

if ($null -ne $LanguageIndex) {
    # Collect the layouts to be removed
    $LayoutsToRemove = @()
    foreach ($kb in $LanguageList[$LanguageIndex].InputMethodTips) {
        if ($KeyboardsToRemove.Contains($kb) -and -not $KeyboardsToKeep.Contains($kb)) {
            $LayoutsToRemove += $kb
        }
    }

    # Remove the collected layouts
    foreach ($kb in $LayoutsToRemove) {
        $LanguageList[$LanguageIndex].InputMethodTips.Remove($kb) | Out-Null
        Write-Host "Removed: $kb"
    }

    Set-WinUserLanguageList $LanguageList -Force
} else {
    Write-Host "Persian (fa-IR) not found in the language list."
}
