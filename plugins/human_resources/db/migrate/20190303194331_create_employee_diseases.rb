class CreateEmployeeDiseases < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_diseases do |t|
      t.belongs_to :employee, index: true
      t.string :name, null: false
      t.text :description
    end
  end
end
