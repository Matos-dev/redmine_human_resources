class EmployeeDisease < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :employee
end