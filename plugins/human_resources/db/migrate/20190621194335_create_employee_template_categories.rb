class CreateEmployeeTemplateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_template_categories do |t|
      t.string :name
      t.string :alias
      t.text :description
    end
  end
end
