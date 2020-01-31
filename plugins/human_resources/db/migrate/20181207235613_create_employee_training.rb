class CreateEmployeeTraining < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_trainings do |t|
      t.belongs_to :employee
      t.column :evaluation_id, :integer, default: 4
      t.column :description, :text
      t.timestamps(null: false)
    end
  end
end
