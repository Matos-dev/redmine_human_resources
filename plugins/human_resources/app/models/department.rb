class Department < ActiveRecord::Base
  has_many :employee, dependent: :restrict_with_error
  has_many :employee_template_by_department, dependent: :destroy
  has_many :employee_template, through: :employee_template_by_department
  validates_presence_of :name
  validates_uniqueness_of :name

  if Redmine::VERSION.to_s < '3.0'
    acts_as_nested_set :order => 'name', :dependent => :destroy
  else
    include DepartmentNestedSet
  end

  def all_childs
    Department.where('lft > ? AND rgt < ?', lft, rgt).order('lft')
  end

  def css_classes
    s = 'project'
    s << ' root' if root?
    s << ' child' if child?
    s << (leaf? ? ' leaf' : ' parent')
    s
  end

  def allowed_parents
    return @allowed_parents if @allowed_parents
    @allowed_parents = Department.all - self_and_descendants - [self]
    @allowed_parents << nil
  end

  class << self
    # Yields the given block for each department with its level in the tree
    def department_tree(departments, &block)
      ancestors = []
      departments.sort_by(&:lft).each do |department|
        while (ancestors.any? && !department.is_descendant_of?(ancestors.last))
          ancestors.pop
        end
        yield department, ancestors.size
        ancestors << department
      end
    end

    def all_visible_departments
      Department.order(:name)
    end
  end

  def get_templates_of_department
    employee_template_by_department.includes(:employee_template).joins(
        :employee_template).where('employee_templates.rga_template = ? and total_templates > ?', false, 0)
  end
end
