class AddRgaTemplateToEmployeeTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_templates, :rga_template, :boolean
  end
end
