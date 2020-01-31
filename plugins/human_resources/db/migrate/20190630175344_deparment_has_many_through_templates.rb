class DeparmentHasManyThroughTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_template_by_departments do |t|
      t.belongs_to :department, index: true
      t.belongs_to :employee_template, index: true
      t.integer :total_templates, default: 0
      t.integer :real_templates, default: 0
      t.timestamps null: false
    end
  end
end
