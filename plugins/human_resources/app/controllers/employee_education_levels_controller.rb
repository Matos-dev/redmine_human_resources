class EmployeeEducationLevelsController < ApplicationController
  before_action :require_login
  before_action :find_employee_education_level, only: %i[edit update destroy]
  before_action :authorize_global
  def index
    @education_levels = EmployeeEducationLevel.all
  end

  def show; end

  def edit; end

  def new
    @education_level = EmployeeEducationLevel.new
  end

  def update
    if @education_level.update(education_levels_params)
      redirect_to employee_education_levels_path, notice: "#{l(:successfully_updated)}"
    else
      render :edit
    end
  end

  def create
    @education_level = EmployeeEducationLevel.new(education_levels_params)
    if @education_level.save
      redirect_to employee_education_levels_path, notice: "#{l(:successfully_created)}"
    else
      render :new
    end
  end

  def destroy
    @education_level.destroy
    redirect_to employee_education_levels_path, notice: "#{l(:successfully_delete)}"
  end

  private

  def find_employee_education_level
    @education_level = EmployeeEducationLevel.find(params[:id])
  end

  def education_levels_params
    params.require(:employee_education_level).permit(:name, :alias, :description)
  end
end
