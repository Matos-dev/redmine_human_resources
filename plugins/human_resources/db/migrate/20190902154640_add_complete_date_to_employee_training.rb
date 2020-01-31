class AddCompleteDateToEmployeeTraining < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_trainings, :training_date, :date
  end
end
