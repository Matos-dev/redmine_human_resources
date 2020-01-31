class EmployeeContractTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_contract_types do |t|
      t.string :name
      t.text :description
      t.boolean :fixed_position
    end
  end
end
