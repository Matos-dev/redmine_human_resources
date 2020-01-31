class CreateEmployeeSalaryKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_salary_keys do |t|
      t.belongs_to :employee, index: true
      t.string :name
      t.column :amount, :integer, default: 0
      t.column :description, :text
      t.timestamps(null: false)
    end
  end
end
