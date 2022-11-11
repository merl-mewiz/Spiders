class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    # @tasks = Task.all
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      redirect_to tasks_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task information updated successfully'
      redirect_to tasks_path
    else
      flash[:danger] = 'An error occurred while changing the task'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    task_title = @task.title

    if @task.destroy
      flash[:success] = "Task \"#{task_title}\" deleted successfully"
      redirect_to tasks_path
    else
      flash[:danger] = 'An error occurred while deleting a task'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority_id, :status_id, :deadline)
  end
end
