class DeleteAcronymFromEmployeeTemplate < ActiveRecord::Migration[5.2]
  def change
    remove_column :employee_templates, :acronym, :string
  end
end
