class EmployeeWorkExperiencesController < ApplicationController
  before_action :require_login
  before_action :find_work_experience, only: %i[edit_experience update_experience destroy]
  before_action :find_employee, only: %i[create_experience update_experience new_experience edit_experience]
  before_action :authorize_global
  include EmployeeHelper
  include SortHelper

  def edit_experience
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_experience
    @work_experience = EmployeeWorkExperience.new
  end

  def update_experience
    if @work_experience.update(work_experience_params)
      respond_to do |format|
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html {
          render action: 'edit_experience',
                 id: params[:id],
                 wexp_id: params[:wexp_id]
        }
        format.js {
          render action: 'edit_experience',
                 id: params[:id],
                 wexp_id: params[:wexp_id]
        }
      end
    end
  end

  def create_experience
    @work_experience = EmployeeWorkExperience.new(work_experience_params)
    @work_experience.employee_id = params[:id]
    if @work_experience.save
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
        format.html {
          render action: 'new_experience',
                 id: params[:id]
        }
        format.js {
          render action: 'new_experience',
                 id: params[:id]
        }
      end
    end
  end

  def destroy
    @work_experience.destroy
    redirect_to employee_path(params[:id]), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def find_work_experience
    @work_experience = EmployeeWorkExperience.find(params[:wexp_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def work_experience_params
    params.require(:employee_work_experience).permit(:previous_company_name, :job_title, :from_date, :to_date, :description)
  end
end
