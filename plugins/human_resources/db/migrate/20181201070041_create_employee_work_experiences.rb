class CreateEmployeeWorkExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_work_experiences do |t|
      t.string :previous_company_name
      t.string :job_title, null: false
      t.datetime :from_date
      t.datetime :to_date
      t.text :description
      t.belongs_to :employee, index: true
    end
  end
end
