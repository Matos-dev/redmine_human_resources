class EmployeeEducationalsController < ApplicationController
  before_action :require_login
  before_action :find_educational_data, only: %i[edit_educational_data update_educational_data destroy]
  before_action :find_employee, only: %i[create_educational_data update_educational_data new_educational_data edit_educational_data]
  before_action :authorize_global
  include EmployeeHelper
  include SortHelper
  include EmployeeNomenclatorsHelper
  helper :employee_nomenclators

  def edit_educational_data
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_educational_data
    @educational_data = EmployeeEducational.new
  end

  def update_educational_data
    if @educational_data.update(educational_params)
      respond_to do |format|
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'edit_educational_data',
                 id: params[:id],
                 edu_id: params[:edu_id]
        end
        format.js do
          render action: 'edit_educational_data',
                 id: params[:id],
                 edu_id: params[:edu_id]
        end
      end
    end
  end

  def create_educational_data
    @educational_data = EmployeeEducational.new(educational_params)
    @educational_data.employee_id = params[:id]
    if @educational_data.save
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
          render action: 'new_educational_data',
                 id: params[:id]
        end
        format.js do
          render action: 'new_educational_data',
                 id: params[:id]
        end
      end
    end
  end

  def destroy
    @educational_data.destroy
    redirect_to employee_path(params[:id]), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def find_educational_data
    @educational_data = EmployeeEducational.find(params[:edu_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def educational_params
    params.require(:employee_educational).permit(:institution, :speciality,
                                                  :start_date, :complete_date,
                                                  :education_level_id)
  end
end
