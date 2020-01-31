class EmployeeTemplate < ActiveRecord::Base
  belongs_to :employee_template_category, foreign_key: :template_categoy_id

  has_many :employee_template_join_competence
  has_many :employee_competence, through: :employee_template_join_competence
  has_many :employee, dependent: :restrict_with_error
  belongs_to :employee_template_category, class_name: 'EmployeeTemplateCategory', foreign_key: :template_category_id
  belongs_to :employee_salary_scale, class_name: 'EmployeeSalaryScale', foreign_key: :salary_scale_id

  has_many :employee_template_by_department, dependent: :destroy
  has_many :department, through: :employee_template_by_department
  has_and_belongs_to_many :employee_education_level,
                          class_name: 'EmployeeEducationLevel',
                                join_table: 'employee_education_levels_templates',
                                foreign_key: 'education_level_id',
                                association_foreign_key: 'template_id'

  validates_presence_of :name, :template_category_id, :salary_scale_id
  validates_uniqueness_of :name, case_sensitive: false
end