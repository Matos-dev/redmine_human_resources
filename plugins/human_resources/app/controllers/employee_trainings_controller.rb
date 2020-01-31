class EmployeeTrainingsController < ApplicationController
  before_action :require_login
  before_action :find_training, only: %i[edit_training update_training destroy]
  before_action :find_employee, only: %i[create_training update_training new_training edit_training]
  before_action :authorize_global
  include EmployeeHelper
  include SortHelper

  def edit_training
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_training
    @training = EmployeeTraining.new
  end

  def update_training
    if @training.update(training_params)
      respond_to do |format|
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'edit_training',
                 id: params[:id],
                 training_id: params[:training_id]
        end
        format.js do
          render action: 'edit_training',
                 id: params[:id],
                 training_id: params[:training_id]
        end
      end
    end
  end

  def create_training
    @training = EmployeeTraining.new(training_params)
    @training.employee_id = params[:id]
    if @training.save
      respond_to do |format|
        format.html do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
          redirect_to employee_path(@employee)
        end
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'new_training',
                 id: params[:id]
        end
        format.js do
          render action: 'new_training',
                 id: params[:id]
        end
      end
    end
  end

  def destroy
    @training.destroy
    redirect_to employee_path(params[:id]), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def find_training
    @training = EmployeeTraining.find(params[:training_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def training_params
    params.require(:employee_training).permit(:training_date, :description)
  end
end
