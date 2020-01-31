class CreateEmployeeSalaryScales < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_salary_scales do |t|
      t.string :scale
    end

    add_column :employee_templates, :salary_scale_id, :integer, default: 1
    remove_column :employee_templates, :job_group, :string
  end
end
