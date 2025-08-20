Param(
  [string]$AppDir = "taskqueue"
)

$ErrorActionPreference = "Stop"

function Require-Cmd($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    Write-Error "$name não encontrado no PATH."
  }
}

Require-Cmd php
Require-Cmd composer
Require-Cmd node
Require-Cmd npm

Write-Host "==> Criando projeto Laravel em .\$AppDir"
if (Test-Path $AppDir) {
  Write-Error "Pasta $AppDir já existe. Remova/renomeie e rode novamente."
}

composer create-project laravel/laravel $AppDir

Set-Location $AppDir

Write-Host "==> Instalando laravel/horizon e predis/predis"
composer require laravel/horizon predis/predis

Write-Host "==> Aplicando patches"
$root = (Get-Location).Path
$patches = (Resolve-Path "..\patches").Path
robocopy $patches $root /E

Write-Host "==> Instalando Vue e plugin do Vite"
npm install
npm install vue @vitejs/plugin-vue

Write-Host "==> Gerando chave e migrando banco"
if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
}
php artisan key:generate
php artisan migrate

Write-Host "==> Tudo pronto!"
Write-Host "- App: php artisan serve"
Write-Host "- Horizon: php artisan horizon"
