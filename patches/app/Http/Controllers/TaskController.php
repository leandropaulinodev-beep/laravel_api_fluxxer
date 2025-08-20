<?php

namespace App\Http\Controllers;

use App\Jobs\ProcessTask;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index()
    {
        return Task::orderByDesc('created_at')->get();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
        ]);

        // Cria como pending
        $task = Task::create([
            'title' => $validated['title'],
            'status' => 'pending',
        ]);

        // Atualiza para processing e dispara o job
        $task->update(['status' => 'processing']);
        ProcessTask::dispatch($task->id)->onQueue('default');

        return response()->json($task->fresh(), 201);
    }
}
