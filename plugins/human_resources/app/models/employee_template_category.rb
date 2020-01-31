class EmployeeTemplateCategory < ActiveRecord::Base
  validates_presence_of :name, :alias
  validates_uniqueness_of :name, :alias, case_sensitive: false
end