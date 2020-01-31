class EmployeeTemplateByDepartmentController < ApplicationController
  before_action :require_login
  before_action :find_department, only: %i[edit_template_by_department update_template_by_department]
  before_action :find_templates, only: %i[edit_template_by_department update_template_by_department]
  before_action :authorize_global
  include EmployeeHelper
  include EmployeeTemplateByDepartmentHelper
  include SortHelper

  def edit_template_by_department
    @employee_templates = EmployeeTemplate.all.order(name: 'ASC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update_template_by_department
    if manage_templates
      respond_to do |format|
        format.js do
          flash[:notice] = "#{l(:label_department)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'edit_template_by_department',
                 id: params[:id]
        end
        format.js do
          render action: 'edit_template_by_department',
                 id: params[:id]
        end
      end
    end
  end

  def manage_templates
    templates_values = params[:templates_values]
    can_update = true
    templates_values.each do |k, v|
      @temp_in_dept = EmployeeTemplateByDepartment.find_by(department_id: params[:id], employee_template_id: k)
      if @temp_in_dept.present?
        if v.to_i >= @temp_in_dept.real_templates
          @temp_in_dept.update_attribute(:total_templates, v.to_i)
        else
          can_update = false
        end
      else
        @temp_in_dept = EmployeeTemplateByDepartment.new(department_id: params[:id],
                                                        employee_template_id: k.to_i,
                                                        total_templates: v.to_i,
                                                        real_templates: 0)
        @temp_in_dept.save
      end
    end

    @temp_in_dept.errors.add(:base, l(:templates_by_department_not_update)) unless can_update
    can_update
  end

  private

  def find_department
    @department = Department.find(params[:id])
  end

  def find_templates
    @employee_templates = EmployeeTemplate.all
  end
end