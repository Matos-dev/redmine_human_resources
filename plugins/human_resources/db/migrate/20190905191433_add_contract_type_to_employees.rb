class AddContractTypeToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :contract_type_id, :integer
  end
end
