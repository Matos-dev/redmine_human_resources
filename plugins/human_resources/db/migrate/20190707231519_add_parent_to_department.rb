class AddParentToDepartment < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :parent_id, :integer
    add_column :departments, :lft, :integer
    add_column :departments, :rgt, :integer
    add_timestamps :departments, null: false, default: Time.current
  end
end
