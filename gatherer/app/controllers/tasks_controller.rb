class TasksController < ApplicationController
  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task].permit(:size))
      redirect_to @task, notice: "'project was successfully updated.'"
    else
      render action: "edit"
    end
  end

  def show
    @task = Task.find(params[:id])
  end
end
