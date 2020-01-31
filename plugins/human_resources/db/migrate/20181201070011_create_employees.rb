class CreateEmployees < ActiveRecord::Migration[5.2]
  def self.up
    create_table :employees, force: true do |t|
      t.string  :ni, null: false
      t.string  :name, null: false
      t.string  :race, null: false
      t.string  :email
      t.string  :telephone
      t.string  :salary_card
      t.string  :gender, null: false
      t.date    :job_init_date, default: Date.today, null: false
      t.date    :job_due_date
      t.boolean :active, default: true
      t.string  :address
      t.text    :comments
      t.text    :avatar
      t.belongs_to :employee_template, index: true, null: false
      t.belongs_to :department, index: true, null: false
      t.date :birthday
    end
  end

  def self.down
    drop_table :employees
  end
end
