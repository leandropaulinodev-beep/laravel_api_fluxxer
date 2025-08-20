import './bootstrap';
import { createApp } from 'vue';
import TaskList from './components/TaskList.vue';

createApp({
    components: { TaskList }
}).mount('#app');
