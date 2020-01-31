require 'active_record/fixtures'
class LoadEducationLevelsAndTemplateCategories < ActiveRecord::Migration[5.2]
  def self.up
    directory = File.join(File.dirname(__FILE__), 'data')
    ActiveRecord::FixtureSet.create_fixtures(directory, 'employee_education_levels')
    directory = File.join(File.dirname(__FILE__), 'data')
    ActiveRecord::FixtureSet.create_fixtures(directory, 'employee_template_categories')
  end

  def self.down
    EmployeeEducationLevel.delete_all
    EmployeeTemplateCategory.delete_all
  end
end
