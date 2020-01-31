class EmployeeSalaryScale < ActiveRecord::Base
  validates_presence_of :scale
  validates_uniqueness_of :scale, case_sensitive: false
end
