class EmployeeWorkExperience < ActiveRecord::Base
  belongs_to :employee
  validates_presence_of :job_title, :previous_company_name
end
