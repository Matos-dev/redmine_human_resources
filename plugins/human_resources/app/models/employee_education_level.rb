class EmployeeEducationLevel < ActiveRecord::Base
  has_many :employee_template
  validates_presence_of :name, :alias
  validates_uniqueness_of :name, :alias, case_sensitive: false
end