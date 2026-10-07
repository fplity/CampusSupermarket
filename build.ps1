[CmdletBinding()]
param([string]$JdkHome = $env:JAVA_HOME)

$ErrorActionPreference = 'Stop'
$taskProjectRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$taskBuildRoot = [IO.Path]::GetFullPath((Join-Path $taskProjectRoot 'build'))
$taskJavaRoot = Join-Path $taskProjectRoot 'CS\src\main\java'
$taskWebRoot = Join-Path $taskProjectRoot 'CS\src\main\webapp'
$taskWebOutput = Join-Path $taskBuildRoot 'webapp'
$taskClasses = Join-Path $taskWebOutput 'WEB-INF\classes'

if (-not $JdkHome) {
    $taskJavaCommand = Get-Command java -ErrorAction Stop
    $taskJavaInfo = [Diagnostics.ProcessStartInfo]::new()
    $taskJavaInfo.FileName = $taskJavaCommand.Source
    $taskJavaInfo.Arguments = '-XshowSettings:properties -version'
    $taskJavaInfo.UseShellExecute = $false
    $taskJavaInfo.CreateNoWindow = $true
    $taskJavaInfo.RedirectStandardError = $true
    $taskJavaProcess = [Diagnostics.Process]::Start($taskJavaInfo)
    $taskJavaSettings = $taskJavaProcess.StandardError.ReadToEnd()
    $taskJavaProcess.WaitForExit()
    $taskHomeMatch = [regex]::Match($taskJavaSettings, '(?m)^\s*java\.home\s*=\s*(.+)$')
    if ($taskHomeMatch.Success) {
        $JdkHome = $taskHomeMatch.Groups[1].Value.Trim()
    }
    $taskJavaProcess.Dispose()
}
if (-not $JdkHome) {
    throw 'Set JAVA_HOME or supply -JdkHome with a complete JDK installation.'
}
$taskJavac = Join-Path $JdkHome 'bin\javac.exe'
$taskJar = Join-Path $JdkHome 'bin\jar.exe'
if (-not (Test-Path -LiteralPath $taskJavac) -or -not (Test-Path -LiteralPath $taskJar)) {
    throw 'JdkHome must contain bin\javac.exe and bin\jar.exe.'
}
if ($taskBuildRoot -ne (Join-Path $taskProjectRoot 'build')) {
    throw 'Build output must stay inside the project build directory.'
}
if (Test-Path -LiteralPath $taskBuildRoot) {
    Remove-Item -LiteralPath $taskBuildRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $taskWebOutput -Force | Out-Null
Get-ChildItem -LiteralPath $taskWebRoot -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $taskWebOutput -Recurse -Force
}
New-Item -ItemType Directory -Path $taskClasses -Force | Out-Null

$taskSourceFiles = @(Get-ChildItem -LiteralPath $taskJavaRoot -Recurse -File -Filter '*.java')
if ($taskSourceFiles.Count -eq 0) {
    throw 'No Java source files found.'
}
$taskSourceList = Join-Path $taskBuildRoot 'sources.txt'
$taskSourceLines = $taskSourceFiles | ForEach-Object { '"' + $_.FullName.Replace('\', '/') + '"' }
[IO.File]::WriteAllLines($taskSourceList, [string[]]$taskSourceLines, [Text.UTF8Encoding]::new($false))
& $taskJavac --release 17 -encoding UTF-8 -classpath (Join-Path $taskWebRoot 'WEB-INF\lib\*') -d $taskClasses ('@' + $taskSourceList)
if ($LASTEXITCODE -ne 0) {
    throw 'Java compilation failed.'
}

# Tomcat provides the Servlet API at runtime.
$taskServletApi = Join-Path $taskWebOutput 'WEB-INF\lib\servlet-api.jar'
if (Test-Path -LiteralPath $taskServletApi) {
    Remove-Item -LiteralPath $taskServletApi -Force
}
$taskWar = Join-Path $taskBuildRoot 'webapp.war'
& $taskJar --create --file $taskWar -C $taskWebOutput .
if ($LASTEXITCODE -ne 0) {
    throw 'WAR packaging failed.'
}
Write-Host ('Compiled {0} Java source files.' -f $taskSourceFiles.Count)
Write-Host ('Exploded application: ' + $taskWebOutput)
Write-Host ('WAR application: ' + $taskWar)
