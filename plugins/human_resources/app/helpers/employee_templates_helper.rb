module EmployeeTemplatesHelper
  def retrieve_templates
    EmployeeTemplate.all.select(:id, :name)
  end

  def retrieve_template_categories
    EmployeeTemplateCategory.all.select(:id, :name)
  end

  def retrieve_template_category(id)
    EmployeeTemplateCategory.find_by_id(id)
  end

  def retrieve_salary_scales
    EmployeeSalaryScale.all.select(:id, :scale)
  end
end
