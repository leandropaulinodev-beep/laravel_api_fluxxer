<template>
  <div class="container" style="max-width:720px;margin:2rem auto;">
    <h1>Tasks</h1>

    <form @submit.prevent="createTask" style="margin:1rem 0;">
      <input v-model="title" type="text" placeholder="Título da task" required />
      <button type="submit">Criar</button>
    </form>

    <div v-if="loading">Carregando...</div>

    <ul v-else>
      <li v-for="t in tasks" :key="t.id" style="margin:.5rem 0;">
        <strong>{{ t.title }}</strong> — <em>{{ t.status }}</em>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const tasks = ref([]);
const title = ref('');
const loading = ref(false);

async function fetchTasks() {
  loading.value = true;
  try {
    const res = await fetch('/api/tasks');
    tasks.value = await res.json();
  } finally {
    loading.value = false;
  }
}

async function createTask() {
  if (!title.value.trim()) return;
  const res = await fetch('/api/tasks', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: JSON.stringify({ title: title.value.trim() })
  });
  if (res.ok) {
    title.value = '';
    await fetchTasks();
  } else {
    const err = await res.json().catch(() => ({}));
    alert('Erro ao criar task: ' + (err.message || res.status));
  }
}

onMounted(fetchTasks);
</script>

<style>
.container input { padding: .5rem; }
.container button { margin-left: .5rem; padding: .5rem 1rem; }
</style>
