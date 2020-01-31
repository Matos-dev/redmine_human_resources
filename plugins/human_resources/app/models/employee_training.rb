class EmployeeTraining < ActiveRecord::Base
  validates_presence_of :description
  belongs_to :employee
end