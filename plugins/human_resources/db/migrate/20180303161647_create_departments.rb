class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
  create_table :departments do |f|
    f.string :name, null: false
    f.text :description
    f.boolean :active, default: true
  end
  end
end
