# COMPILE.ps1

Write-Host "Setting up..."
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$include_dir_1 = Join-Path $scriptDir "..\SDL2\include"
$include_dir_2 = Join-Path $scriptDir "..\include"
$lib_dir = Join-Path $scriptDir "..\bin\lib"
$build_dir = Join-Path $scriptDir "..\build"
$obj_dir = Join-Path $scriptDir "..\objs"
$src = Join-Path $scriptDir "..\src"
$exe_name = Read-Host "Enter the final output name of the app. (make sure to include .exe if needed)"

if (-not ((Test-Path $include_dir_1) -or (Test-Path $include_dir_2) -or (Test-Path $src) -or (Test-Path $lib_dir))) {
    Write-Error "[Error] Important files not found! Try cloning the repo again!" -ForegroundColor Red
    exit 1
}

if (-not $exe_name.Trim()) {
    Write-Host "[Error] Output file name not specified! Terminating build process..." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $build_dir)) {
    New-Item -ItemType Directory -Path $build_dir
}

if (Test-Path $obj_dir) {
    Remove-Item -Recurse -Path $obj_dir
}

New-Item -ItemType Directory -Path $obj_dir

Write-Host "Done!" -ForegroundColor Green
Write-Host "Compiling files..."
foreach ($cpp in Get-ChildItem -Path $src -Filter *.cpp) {
    Write-Host "Compiling $cpp"
    & g++ -c $cpp -I"$include_dir_1" -I"$include_dir_2" -o Join-Path $obj_dir "$($cpp.BaseName).o"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[Error] Compilation failed! Terminating build process..."
        exit 1
    }
}

Write-Host "Done!" -ForegroundColor Green
Write-Host "Building executable..."
& g++ -o "$(Join-Path $obj_dir "*.o")" "$(Join-Path $build_dir $exe_name)" -L"$lib_dir" -SDL2main -SDL2 -mwindows
if ($LASTEXITCODE -ne 0) {
    Write-Host "[Error] Linking failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Success! Generated executable on $(Join-Path $build_dir $exe_name)" -ForegroundColor Green

$run = Read-Host "Launch program? y/n"
if (($run -eq "y") -or ($run -eq "Y")) {
    Write-Host "Running executable..."
    Start-Process -FilePath "$(Join-Path $build_dir $exe_name)"
}
else {
    exit 1
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Program quit unsuccessfully." -ForegroundColor Red
    exit 1
}

Write-Host "Program quit successfully!" -ForegroundColor Green