#!/usr/bin/env bash
set -euo pipefail

APP_DIR="taskqueue"

echo "==> Checando dependências: php, composer, node, npm"
command -v php >/dev/null 2>&1 || { echo "PHP não encontrado"; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "Composer não encontrado"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node não encontrado"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "NPM não encontrado"; exit 1; }

echo "==> Criando projeto Laravel em ./${APP_DIR}"
if [ -d "${APP_DIR}" ]; then
  echo "Pasta ${APP_DIR} já existe. Remova ou renomeie e rode novamente."
  exit 1
fi

composer create-project laravel/laravel "${APP_DIR}"

cd "${APP_DIR}"

echo "==> Instalando pacotes: laravel/horizon e predis/predis"
composer require laravel/horizon predis/predis

echo "==> Aplicando patches"
ROOT="$(pwd)"
PATCHES_DIR="$(cd .. && pwd)/patches"
rsync -a "${PATCHES_DIR}/" "${ROOT}/"

echo "==> Instalando Vue e plugin do Vite"
npm install
npm install vue @vitejs/plugin-vue

echo "==> Gerando chave e migrando banco"
cp -n .env.example .env || true
php artisan key:generate
php artisan migrate

echo "==> Tudo pronto!"
echo "- App: php artisan serve"
echo "- Horizon: php artisan horizon"
