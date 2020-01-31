class EmployeeTemplateByDepartment < ActiveRecord::Base
  belongs_to :employee_template
  belongs_to :department
  validates_numericality_of :total_templates, greater_than_or_equal_to: 0
end