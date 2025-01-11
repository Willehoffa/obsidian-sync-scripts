# ObsidianGitSync.ps1
# Configuration 

$vaultPath = #"Path_To_Vault"
$commitMessage = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$logFile = #"Path_To_Log\obsidian-sync.log"

# Funtion to write to log file 
function Write-Tolog {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
    Write-Host $Message
}

# Error Handling 
$ErrorActionPreference = "Stop"

try {
    # Navigate to vault directory 
    Set-Location -Path $vaultPath
    Write-Tolog "Change directory to $vaultPath"

    # Pull changes first 
    Write-Tolog "Pulling changes from remote repository..."
    & git pull origin main 
    
    # Check for changes 
    $status = & git status --porcelain
    if ($status) {
        # Add all Changes 
        Write-Tolog "Changes detected, commiting..."
        & git add --all

        # Commit Changes 
        & git commit -m $commitMessage

        # Push Changes 
        Write-Tolog "Push changes to remote repsitory..."
        & git push origin main

        Write-Tolog "Sync completed successfully with changes"

    } else {
        Write-Tolog "No changes detected"
    }
} catch {
    $errorMessage = $_.Exception.Message
    Write-Tolog "Error occured: $errorMessage"
    Write-Tolog "Stack trace: $($_Exception.StackTrace)"
    exit 1
}
