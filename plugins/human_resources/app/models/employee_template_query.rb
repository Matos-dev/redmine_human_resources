class EmployeeTemplateQuery < Query
  self.queried_class = EmployeeTemplate

  self.available_columns = []

  def initialize(attributes = nil, *args)
    super attributes
    self.filters ||= self.filters ||= { 'name' => { operator: '*', values: [] } }
  end

  def initialize_available_filters
    add_available_filter "name", type: :string
    add_available_filter "template_category_id",
                         type: :list, values: EmployeeTemplateCategory.all.collect{|s| [s.name, s.id.to_s] }
    add_available_filter "salary_scale_id",
                         type: :list, values: EmployeeSalaryScale.all.collect{|s| [s.scale, s.id.to_s] }
  end

  def base_scope
    EmployeeTemplate.where(statement)
  end

  def object_count
    base_scope.count
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid, e.message
  end

  def objects_scope
    EmployeeTemplate
  end

  def results_scope(options = {})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)
    objects_scope.order(order_option)
                 .where(statement)
                 .includes(options[:include])
                 .joins(joins_for_order_statement(order_option.join(',')))
                 .limit(options[:limit])
                 .offset(options[:offset])
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid, e.message
  end

  def detail_count_by_group
    grouped_query(&:count)
  end
end
