class EmployeeSalaryScalesController < ApplicationController
  before_action :require_login
  before_action :find_employee_salary_scale, only: %i[edit update destroy]
  before_action :authorize_global
  def index
    @salary_scales = EmployeeSalaryScale.all.order(:id)
  end

  def show; end

  def edit; end

  def new
    @salary_scale = EmployeeSalaryScale.new
  end

  def update
    if @salary_scale.update(salary_scales_params)
      redirect_to employee_salary_scales_path, notice: "#{l(:successfully_updated)}"
    else
      render :edit
    end
  end

  def create
    @salary_scale = EmployeeSalaryScale.new(salary_scales_params)
    if @salary_scale.save
      redirect_to employee_salary_scales_path, notice: "#{l(:successfully_created)}"
    else
      render :new
    end
  end

  def destroy
    @salary_scale.destroy
    redirect_to employee_salary_scales_path, notice: "#{l(:successfully_delete)}"
  end

  private

  def find_employee_salary_scale
    @salary_scale = EmployeeSalaryScale.find(params[:id])
  end

  def salary_scales_params
    params.require(:employee_salary_scale).permit(:scale, :salary)
  end
end
