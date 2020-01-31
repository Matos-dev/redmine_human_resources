class CreateEmployeeEducationLevelsTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_education_levels_templates, id: false do |t|
      t.belongs_to :template
      t.belongs_to :education_level
    end
  end
end
