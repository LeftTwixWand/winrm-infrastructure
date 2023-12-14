param(
    [string]$URL = $env:AZURE_DEVOPS_ORG,
    [string]$PAT = $env:AZURE_DEVOPS_PAT
)

Write-Host "URL: $URL";
write-host "PAT: $PAT";

# Download the agent
Invoke-WebRequest -uri "https://vstsagentpackage.azureedge.net/agent/3.232.0/vsts-agent-win-x64-3.232.0.zip" -Method "GET"  -Outfile $HOME\Downloads\vsts-agent-win-x64-3.232.0.zip

# Extract the agent
mkdir C:\agent;
cd C:\agent;
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$HOME\Downloads\vsts-agent-win-x64-3.232.0.zip", "$PWD");

# Configure the agent
./config.cmd --unattended `
            --url $URL `
            --auth pat `
            --token $PAT `
            --pool Self-Hosted `
            --agent youragent `
            --runAsService `
            --acceptTeeEula `
            --work _work `
            --replace;