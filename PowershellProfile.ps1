$time = Get-Date
$Env:LC_ALL="C.UTF-8"
Write-Host " _._     _,-'""`-._" -ForegroundColor Green
Write-Host "(,-.`._,'(       |\`-/|" -ForegroundColor Green
Write-Host "    `-.-' \ )-`( , o o)" -ForegroundColor Green
Write-Host "          `-    \`_`"'-" -ForegroundColor Green
Write-Host "`n$($time.ToLongDateString())`n"

## Pretty prompt
function Prompt {
    $curtime = Get-Date

    Write-Host -NoNewLine "[" -ForegroundColor Yellow
    Write-Host -NoNewLine ("{0:HH}:{0:mm}:{0:ss}" -f (Get-Date)) -ForegroundColor Cyan
    Write-Host -NoNewLine "]" -ForegroundColor Yellow
    Write-Host -NoNewline " $((Get-Location).Path)" -ForegroundColor Yellow
    Write-Host -NoNewLine " >" -ForegroundColor Red

    $host.UI.RawUI.WindowTitle = "$((Get-Location).Path)"

    Return " "
}

## Remote powershell
function remote {
    $password = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
    $cred= New-Object System.Management.Automation.PSCredential ("$ip\RdTeam", $password )
    ENter-PSSession -ComputerName $ip -Credential $cred
}

## Invoke function throught remote powershell
function invoke-remote {
    param (
        [string] $command
    )
    $scriptblock = [Scriptblock]::Create($command)
    $password = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
    $cred= New-Object System.Management.Automation.PSCredential ("$ip\RdTeam", $password )
    Invoke-Command -ComputerName $ip -ScriptBlock $scriptblock -credential $cred 
}

## Run testes of a solution
Function runtest {
    param (
        [string] $directory
    )
    $unittests = @()
    Get-ChildItem -Path $directory -Include *test*.dll -Exclude *obj**,*lib**,*Microsoft.VisualStudio.TestPlatform* -Recurse | % { $unittests += $_.FullName }
    $testfilenames = [string]::Join(" ", $unittests)
    Write-Host $testfilenames.fullname
    Invoke-Expression "vstest.console.exe $testfilenames /InIsolation /Parallel"
    Write-Host "Unit Test finish" -ForegroundColor Green
}

## Reset console colors
function reset {
    [Console]::ResetColor()
}

## Clean bin/obj recursively
function binobjclean {
    param(
        [string] $directory
    )
    if (!$directory) {
        $directory = "./"
    }
    Write-Host $directory
    Get-ChildItem $directory -include bin -Recurse | foreach ($_) { remove-item $_.fullname -Force -Recurse }
    Get-ChildItem $directory -include obj -Recurse | foreach ($_) { remove-item $_.fullname -Force -Recurse }
}

## Display a really pretty cat :)
function alvin {
    Write-Host "`n    /\_____/\" -ForegroundColor Green
    Write-Host "   /  o   o  \" -ForegroundColor Green
    Write-Host "  ( ==  ^  == )" -ForegroundColor Green
    Write-Host "   )         (" -ForegroundColor Green
    Write-Host "  (           )" -ForegroundColor Green
    Write-Host " ( (  )   (  ) )" -ForegroundColor Green
    Write-Host "(__(__)___(__)__)`n" -ForegroundColor Green
}
 
## Docker shortcuts...
Function a {
    docker ps -a
}

## Docker shortcuts...
Function sa {
    docker service ls
}

## Docker shortcuts...
Function af
{
    param (
        [string]$name
    )
    if ($name) {
        docker ps -af name=$name
    }
    else {
        docker ps -af name=fast 
    }
}

## Docker shortcuts...
Function saf
{
    param (
        [string]$name
    )
    if ($name) {
        docker service ls -f name=xcut-$name
    }
    else {
        docker service ls -f name=crosscut-fast
    }
}

## Docker shortcuts...
Function log
{
    param (
        [string]$container
    )
    if ($container) {
        docker logs --tail 100 $container
    }
}

## Docker shortcuts...
Function slog
{
    param (
        [string]$container
    )
    if ($container) {
        docker service logs --tail 100 $container
    }
}

## Scales to 0 a docker service 
function kil {
    param(
        [string] $truc
    )
    docker service scale $truc=0
}

## Restart a docker (scale to 0 then to 1)
function ress {
    param (
        [string]$containerId
    )
    if ($containerId) {
        docker service scale $containerId=0
        docker service scale $containerId=1
    }
}

## Randomize console colors
function randomize {
    $colorToolPath = "\ColorTool"
    $randomColorFile = Get-ChildItem -Path "$($colorToolPath)\schemes" -Filter *.itermcolors -Recurse -File -Name | Get-Random
    & "$($colorToolPath)\ColorTool.exe" $randomColorFile
}

## Launch an admin console 
function sudo {
    Start-Process -FilePath powershell.exe -Argument "-nologo -noexit -command `"Set-Location $PWD`"" -Verb RunAs
 }


## Get console history from a $string
Function hist {
    param(
        [string] $stringToFind
    )
    if ($stringToFind) {
        cat (Get-PSReadlineOption).HistorySavePath | Select-String -Pattern $stringToFind
    }
    else {
        cat (Get-PSReadlineOption).HistorySavePath
    }
}

## Encode a powershell command
Function Encode-Command {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]     
        [string] $command
    )
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
    $encodedCommand = [Convert]::ToBase64String($bytes)
    return $encodedCommand
}

## Clear local nugets
Function clearnuget {
    NuGet.exe locals all -Clear
}

## Switch to different docker environment
Function sd
{
    param(
        [string]$type = $null
    )
    if ($type -eq "build")
        { . "$Env:USERPROFILE\.docker\build\switch-docker.ps1"; af }
    elseif ($type -eq "local")
        { . "$Env:USERPROFILE\.docker\local\switch-docker.ps1"; af }
    else {
        Write-Host "Trying to access... nothing ! ^-^" -ForegroundColor Green
        Write-Host "Try again !" -ForegroundColor Green
    }
}