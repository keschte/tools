# Use this file to run your own startup commands

## Prompt Customization
<#
.SYNTAX
    <PrePrompt><CMDER DEFAULT>
    λ <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\cmder [master]
    λ <PostPrompt> |
#>

[ScriptBlock]$PrePrompt = {
    $Host.UI.RawUI.ForegroundColor = "White"
    Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    checkGit($pwd.ProviderPath)
}

# Replace the cmder prompt entirely with this.
[ScriptBlock]$CmderPrompt = {

}

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>

