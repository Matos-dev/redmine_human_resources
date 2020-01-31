class AddSalaryToEmployeeSalaryScales < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_salary_scales, :salary, :float, default: 0.0
  end
end
