class CreateEmployeeEducationLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_education_levels do |t|
      t.string :name
      t.string :alias
      t.text :description
    end
  end
end
