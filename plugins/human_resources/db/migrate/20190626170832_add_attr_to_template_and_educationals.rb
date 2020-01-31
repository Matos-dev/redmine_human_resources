class AddAttrToTemplateAndEducationals < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_educationals, :education_level_id, :integer
    remove_column :employee_educationals, :degree, :string
    add_column :employee_templates, :template_category_id, :integer
    remove_column :employee_templates, :job_category, :string
  end
end
