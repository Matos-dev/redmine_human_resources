class CreateEmployeeEducationals < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_educationals do |t|
      t.string :institution, null: false
      t.string :speciality, null: false
      t.date :start_date, null: false
      t.date :complete_date
      t.string :degree
      t.belongs_to :employee, index: true
    end
  end
end
