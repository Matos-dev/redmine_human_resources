require 'active_record/fixtures'
class LoadEmployeeSalaryScales < ActiveRecord::Migration[5.2]
  def self.up
    directory = File.join(File.dirname(__FILE__), 'data')
    ActiveRecord::FixtureSet.create_fixtures(directory, 'employee_salary_scales')
  end

  def self.down
    EmployeeSalaryScale.delete_all
  end
end
