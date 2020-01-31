module EmployeeTemplateByDepartmentHelper
  def count_templates_in_department(department_id, template_id)
    ed = EmployeeTemplateByDepartment.find_by(department_id: department_id, employee_template_id: template_id)
    ed.present? ? ed.total_templates : 0
  end

  def availability_of_template(temp_by_dep)
    if temp_by_dep.present?
      temp_by_dep.total_templates > temp_by_dep.real_templates
    else
      false
    end
  end

  def register_template(requested_template)
    requested_template.update_attributes(real_templates: requested_template.real_templates + 1)
  end

  def unregister_template
    @current_template.update_attributes(real_templates: @current_template.real_templates - 1)
  end

  def verify_template_before_update(requested_template)
    if requested_template.present?
      if @current_template.department_id == requested_template.department_id &&
         @current_template.employee_template_id == requested_template.employee_template_id
        0
      else
        availability_of_template(requested_template) ? 1 : -1
      end
    else
      false
    end
  end
end
