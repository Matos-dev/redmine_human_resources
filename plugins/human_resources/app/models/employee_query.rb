class EmployeeQuery < Query
  self.queried_class = Employee

  self.available_columns = [
    QueryColumn.new(:avatar, sortable: "#{Employee.table_name}.avatar", caption: :field_avatar, frozen: true),
    QueryColumn.new(:name, sortable: "#{Employee.table_name}.name", caption: :field_name, frozen: true),
    QueryColumn.new(:ni, sortable: "#{Employee.table_name}.ni", caption: :field_ni, frozen: true),
    QueryColumn.new(:gender, sortable: "#{Employee.table_name}.gender", groupable: true, caption: :field_gender, frozen: true),
    QueryColumn.new(:department, groupable: true, frozen: true),
    QueryColumn.new(:employee_contract_type, groupable: true, caption: :field_contract_type),
    QueryColumn.new(:employee_template, groupable: true, frozen: true),
    QueryColumn.new(:email, sortable: "#{Employee.table_name}.email", caption: :field_employee_email),
    QueryColumn.new(:salary_card, sortable: "#{Employee.table_name}.salary_card", caption: :field_salary_card),
    QueryColumn.new(:job_init_date, sortable: "#{Employee.table_name}.job_init_date", caption: :field_job_init_date),
    QueryColumn.new(:job_due_date, sortable: "#{Employee.table_name}.job_due_date", caption: :field_job_due_date),
    QueryColumn.new(:address, sortable: "#{Employee.table_name}.address", caption: :field_personal_address)
  ]

  def initialize(attributes = nil, *args)
    super attributes
    self.filters ||= { 'active' => { operator: '=', values: [true] } }
  end

  def initialize_available_filters
    add_available_filter 'active', type: :list, values: [[l(:general_text_yes).capitalize, '1'], [l(:general_text_no).capitalize, '0']], label: :field_active
    add_available_filter 'ni', type: :string, label: :field_ni
    add_available_filter 'name', type: :string, label: :field_name
    add_available_filter'gender',
                         type: :list, values: Employee.employee_gender.map{|a,b| b}, label: :field_gender
    add_available_filter "employee_template_id",
                         type: :list, values: EmployeeTemplate.all.collect{|s| [s.name, s.id.to_s] }
    add_available_filter "department_id",
                         type: :list, values: Department.all.collect{|s| [s.name, s.id.to_s] }
    add_available_filter "contract_type_id",
                         type: :list, values: EmployeeContractType.all.collect{|s| [s.name, s.id.to_s] }, label: :field_contract_type
    add_available_filter 'job_init_date', type: :date, label: :field_job_init_date
    add_available_filter 'job_due_date', type: :date, label: :field_job_due_date
    add_available_filter 'email', type: :string, label: :field_employee_email
    add_available_filter 'salary_card', type: :string, label: :field_salary_card
    add_available_filter 'address', type: :text, label: :field_personal_address
   # add_available_filter 'dayst', type: :text
  end

  def base_scope
    Employee.where(statement)
  end

  def object_count
    base_scope.count
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid, e.message
  end

  def objects_scope
    Employee
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

  def sql_for_days_field(field, operator, value)
    sql_for_field(field, operator, value, Invoice.table_name, "amount - #{Invoice.table_name}.balance") +
        " AND #{Invoice.table_name}.status_id IN (#{Invoice::SENT_INVOICE}, #{Invoice::PAID_INVOICE})" +
        " AND #{Invoice.table_name}.due_date <= '#{ActiveRecord::VERSION::MAJOR >= 4 ? self.class.connection.quoted_date(Date.today) : connection.quoted_date(Date.today)}' "
  end
=begin
  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
    @available_columns += CustomField.where(type: 'InvoiceCustomField').all.map { |cf| QueryCustomFieldColumn.new(cf) }
    @available_columns += CustomField.where(type: 'ContactCustomField').all.map { |cf| QueryAssociationCustomFieldColumn.new(:contact, cf) }
    @available_columns
  end

  def default_columns_names
    @default_columns_names ||= %i[number invoice_date subject contact amount status]
  end

  def sql_for_status_id_field(field, operator, value)
    sql = ''
    case operator
    when 'o'
      sql = "#{queried_table_name}.status_id NOT IN (#{Invoice::PAID_INVOICE}, #{Invoice::CANCELED_INVOICE})"
    when 'c'
      sql = "#{queried_table_name}.status_id IN (#{Invoice::PAID_INVOICE}, #{Invoice::CANCELED_INVOICE})"
    when 'd'
      "#{Invoice.table_name}.due_date <= '#{ActiveRecord::VERSION::MAJOR >= 4 ? self.class.connection.quoted_date(Date.today) : connection.quoted_date(Date.today)}' AND #{Invoice.table_name}.status_id = #{Invoice::SENT_INVOICE}"
    else
      sql_for_field(field, operator, value, queried_table_name, field)
    end
  end



  def invoiced_amount
    objects_scope.group("#{Invoice.table_name}.currency").sum(:amount)
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid, e.message
  end

  def paid_amount
    objects_scope.sent_or_paid.group(:currency).sum(:balance)
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid, e.message
  end

  def due_amount
    objects_scope.sent_or_paid.group(:currency).sum("#{Invoice.table_name}.amount - #{Invoice.table_name}.balance")
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid, e.message
  end

  def objects_scope(options = {})
    scope = Invoice.visible
    options[:search].split(' ').collect{ |search_string| scope = scope.live_search(search_string) } unless options[:search].blank?
    scope = scope.includes((query_includes + (options[:include] || [])).uniq).
      where(statement).
      where(options[:conditions])
    scope
  end
=end

=begin
  def query_includes
    includes = %i[stakeholder_entry project]
    includes << {stakeholder_entry: :address} if self.filters['contact_country'] ||
                                                 self.filters['contact_city'] ||
                                                 %i[contact_country contact_city].include?(group_by_column.try(:name))
    includes << :assigned_to if self.filters['assigned_to_id'] || (group_by_column && [:assigned_to].include?(group_by_column.name))
    includes
  end
=end

=begin
  def contact_query_values(values)
    invoices_contacts_for_select(project, where: {id: values}, short_label: true)
  end
=end
end
