module EmployeeHelper
  def build_avatar(avatar)
    base64 = Base64.encode64(avatar[:data]).gsub(/\s+/, '')
    "data:#{avatar[:content_type]};base64,#{Rack::Utils.escape(base64)}"
  end

  def employees_actives
    Employee.actives
  end

  def employees_inactives
    Employee.inactives
  end

  def employees_count
    Employee.count
  end

  def woman_employees
    Employee.where(gender: 'F').count
  end

  def man_employees
    Employee.where(gender: 'M').count
  end

  def calculate_salary(employee)
    salary = employee.employee_template.employee_salary_scale.salary.present? ?
                 employee.employee_template.employee_salary_scale.salary : 0.0
    aditional_pay = employee.salary_keys
    aditional_pay.each { |pay| salary += pay.amount.present? ? pay.amount : 0.0 } if aditional_pay.any?
    salary
  end

  def employee_age(birthday_date)
    birthday_date.present? ? (Date.today.year - birthday_date.year).to_s + ' ' + l(:field_years) : l(:value_not_identify)
  end

  def grouped_employee_list(employees, query, employee_count_by_group, &block)
    previous_group = false
    first = true
    totals_by_group = query.totalable_columns.inject({}) do |h, column|
      h[column] = query.total_by_group_for(column)
      h
    end
    employee_list(employees) do |employee, level|
      group_name = group_count = nil
      if query.grouped?
        group = query.group_by_column.value(employee)
        if first || group != previous_group
          group_name = if group.blank? && group != false
                         "(#{l(:label_blank_value)})"
                         else
                           format_object(grouped_names(query.group_by, group))
                       end
          group_name ||= ''
          group_count = employee_count_by_group[group]
          group_totals = totals_by_group.map { |column, t| total_tag(column, t[group] || 0) }.join(' ').html_safe
        end
      end
      yield employee, level, group_name, group_count, group_totals
      previous_group = group
      first = false
    end
  end

  def employee_list(employees, &block)
    ancestors = []
    employees.each do |employee|
      ancestors.pop while ancestors.any?
      yield employee, ancestors.size
      ancestors << employee
    end
  end

  def grouped_names(name, group)
    case name.to_sym
    when :employee_template
      group.name
    when :department
      group.name
    else
      group
    end
  end
end
