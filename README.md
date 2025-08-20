# API Fluxxer — Laravel + Redis (Horizon) + Vue.js

Este projeto disponível por mim que implementa um **processador de tarefas assíncronas** utilizando **Laravel**, **Redis**, **Laravel Horizon** e **Vue.js**.  
O objetivo é demonstrar boas práticas de API REST, processamento em fila e frontend reativo.

---

## Tecnologias Utilizadas
- **Backend**: Laravel 11, PHP 8.2
- **Fila**: Redis + Laravel Horizon
- **Frontend**: Vue 3 + Vite
- **Banco de Dados**: MySQL

---

##  Funcionalidades
### API
- `POST /api/tasks` — Cria uma nova tarefa com status inicial `pending`, atualiza para `processing` e envia para a fila.
- `GET /api/tasks` — Lista todas as tarefas ordenadas por data de criação (mais recentes primeiro).

### Fila & Horizon
- **Job `ProcessTask`** — Simula processamento (5 segundos) e atualiza o status da tarefa para `done`.
- **Horizon** — Painel de monitoramento em tempo real.

### Frontend
- **Componente `TaskList.vue`**:
  - Lista as tarefas e seus status.
  - Formulário para criar nova tarefa.
  - Atualização automática da lista após criação.

---

##  Instalação e Execução

### 1. Pré-requisitos
- PHP 8.2+
- Composer
- Node.js 18+
- NPM
- Redis em execução (`docker run -d --name redis -p 6379:6379 redis:7-alpine`)

### 2. Instalação
```bash
Clone o repositório
cd seu-repo
composer install
npm install
cp .env.example .env
php artisan key:generate
```

No `.env`, configure:
```
QUEUE_CONNECTION=redis
REDIS_CLIENT=predis
```

### 3. Migrate Database
```bash
php artisan migrate
```

### 4. Executar Projeto
Em terminais separados:
```bash
php artisan serve       # API e frontend
php artisan horizon     # Monitoramento da fila
npm run dev             # Compila assets Vue
```

---

##  Endpoints de Teste

### Criar Task
```bash
curl -X POST http://127.0.0.1:8000/api/tasks -H "Content-Type: application/json" -d '{"title":"Minha primeira tarefa"}'
```

### Listar Tasks
```bash
curl http://127.0.0.1:8000/api/tasks
```

---

## Estrutura do Projeto
```
app/
 ├── Http/Controllers/TaskController.php
 ├── Jobs/ProcessTask.php
 └── Models/Task.php
resources/
 ├── js/components/TaskList.vue
 ├── js/app.js
 └── views/app.blade.php
routes/
 ├── api.php
 └── web.php
```


