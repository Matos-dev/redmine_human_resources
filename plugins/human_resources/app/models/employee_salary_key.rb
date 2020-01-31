class EmployeeSalaryKey < ActiveRecord::Base
  validates_presence_of :name, :amount, :description
  validates_numericality_of :amount, greater_than: 0
  belongs_to :employee
end