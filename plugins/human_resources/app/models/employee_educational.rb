class EmployeeEducational < ActiveRecord::Base
  validates_presence_of :institution, :speciality, :start_date
  belongs_to :employee
  belongs_to :employee_education_level, class_name: 'EmployeeEducationLevel', foreign_key: :education_level_id
end