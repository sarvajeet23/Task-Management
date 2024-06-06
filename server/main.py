from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict
from datetime import datetime
from uuid import uuid4

app = FastAPI()

class Task(BaseModel):
    id: str
    title: str
    status: str
    priority: int
    priority_color_hex: str
    timestamp: datetime
    description: str

class TaskCreate(BaseModel):
    title: str
    status: str
    priority: int
    priority_color_hex: str
    description: str

class TaskList(BaseModel):
    tasks: List[TaskCreate]

tasks = []

@app.post("/tasks/", response_model=Task)
def create_task(task: TaskCreate):
    new_task = Task(
        id=str(uuid4()),
        title=task.title,
        status=task.status,
        priority=task.priority,
        priority_color_hex=task.priority_color_hex,
        timestamp=datetime.now(),
        description=task.description,
    )
    tasks.append(new_task)
    return new_task

@app.post("/tasks/bulk", response_model=List[Task])
def create_tasks(task_list: TaskList):
    new_tasks = []
    for task in task_list.tasks:
        new_task = Task(
            id=str(uuid4()),
            title=task.title,
            status=task.status,
            priority=task.priority,
            priority_color_hex=task.priority_color_hex,
            timestamp=datetime.now(),
            description=task.description,
        )
        tasks.append(new_task)
        new_tasks.append(new_task)
    return new_tasks

@app.get("/tasks/", response_model=List[Task])
def get_tasks():
    return tasks

@app.get("/tasks/{task_id}", response_model=Task)
def get_task(task_id: str):
    for task in tasks:
        if task.id == task_id:
            return task
    raise HTTPException(status_code=404, detail="Task not found")

@app.put("/tasks/{task_id}", response_model=Task)
def update_task(task_id: str, updated_task: Task):
    for index, task in enumerate(tasks):
        if task.id == task_id:
            tasks[index] = updated_task
            tasks[index].id = task_id  # Ensure the ID remains the same
            tasks[index].timestamp = task.timestamp  # Preserve the original timestamp
            return tasks[index]
    raise HTTPException(status_code=404, detail="Task not found")

@app.delete("/tasks/{task_id}", response_model=Task)
def delete_task(task_id: str):
    for index, task in enumerate(tasks):
        if task.id == task_id:
            deleted_task = tasks.pop(index)
            return deleted_task
    raise HTTPException(status_code=404, detail="Task not found")
