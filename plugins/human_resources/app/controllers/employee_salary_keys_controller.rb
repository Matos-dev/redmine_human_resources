class EmployeeSalaryKeysController < ApplicationController
  before_action :require_login
  before_action :find_salary_key, only: %i[edit_salary_key update_salary_key destroy]
  before_action :find_employee, only: %i[create_salary_key update_salary_key new_salary_key edit_salary_key]
  before_action :authorize_global
  include EmployeeHelper
  include SortHelper

  def edit_salary_key
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_salary_key
    @salary_key = EmployeeSalaryKey.new
  end

  def update_salary_key
    if @salary_key.update(salary_key_params)
      respond_to do |format|
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'edit_salary_key',
                 id: params[:id],
                 sk_id: params[:sk_id]
        end
        format.js do
          render action: 'edit_salary_key',
                 id: params[:id],
                 sk_id: params[:sk_id]
        end
      end
    end
  end

  def create_salary_key
    @salary_key = EmployeeSalaryKey.new(salary_key_params)
    @salary_key.employee_id = params[:id]
    if @salary_key.save
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
          render action: 'new_salary_key',
                 id: params[:id]
        end
        format.js do
          render action: 'new_salary_key',
                 id: params[:id]
        end
      end
    end
  end

  def destroy
    @salary_key.destroy
    redirect_to employee_path(params[:id]), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def find_salary_key
    @salary_key = EmployeeSalaryKey.find(params[:sk_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def salary_key_params
    params.require(:employee_salary_key).permit(:name, :amount, :description)
  end
end
