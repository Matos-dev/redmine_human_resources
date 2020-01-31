class CreateEmployeeTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_templates do |t|
      t.string   :acronym, null: false
      t.string   :name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.text     :mission
      t.text     :functions
      t.text     :responsibilities
      t.text     :sociological_profile
      t.text     :occupational_profile
      t.text     :relationships
      t.string   :job_category
      t.string   :job_group
      t.float    :job_salary
    end
  end
end
