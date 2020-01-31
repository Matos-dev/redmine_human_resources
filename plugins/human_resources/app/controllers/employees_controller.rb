class EmployeesController < ApplicationController
  before_action :require_login
  before_action :find_employee, only: %i[edit update show destroy deactivate_employee]
  before_action :find_current_template, only: %i[update destroy deactivate_employee]
  before_action :authorize_global
  include EmployeeHelper
  include SortHelper
  helper :sort
  helper :employee
  include EmployeeTemplateByDepartmentHelper
  helper :employee_template_by_department
  include EmployeeTemplatesHelper
  helper :employee_templates
  helper :departments
  helper :queries
  include QueriesHelper
  include EmployeeQueryHelper
  helper :employee_query
  helper :issues
  include IssuesHelper
  helper :wicked_pdf
  include WickedPdfHelper
  helper :employee_nomenclators
  include EmployeeNomenclatorsHelper

  def index
    retrieve_details_query('employee')
    sort_init(@query.sort_criteria.empty? ? [%w[job_init_date desc]] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a
    if @query.valid?
      @limit = per_page_option

      @employees_count = @query.object_count
      @employees_scope = @query.objects_scope

      @employees_pages = Paginator.new @employees_count, @limit, params['page']
      @offset ||= @employees_pages.offset

      @employees = @query.results_scope(search: params[:search],
                                        order: sort_clause,
                                        limit: @limit,
                                        offset: @offset)
      @employee_count_by_group = @query.detail_count_by_group
      respond_to do |format|
        format.html
        format.pdf(&method(:build_pdf))
      end
    else
      respond_to do |format|
        format.html { render(template: 'employees/index', layout: !request.xhr?) }
        format.any(:csv, :pdf) { render(nothing: true) }
        format.api { render_validation_errors(@query) }
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(template: 'employees/profile.pdf.erb',
                                layout: false,
                                encoding: 'utf8',
                                locals: { employee: @employee })
        pdf = WickedPdf.new.pdf_from_string(html, orientation: 'Landscape')
        send_data(pdf, filename: l(:organization_employee_submenu) + '.pdf', disposition: 'inline',
        margin: { left: 200, right: 0 })
      end
    end
  end

  def edit; end

  def new
    @employee = Employee.new
  end

  def update
    requested_template = EmployeeTemplateByDepartment.find_by(department_id: employee_params[:department_id], employee_template_id: employee_params[:employee_template_id])
    current_employee = Employee.find(params[:id])
    if current_employee.active
      case verify_template_before_update(requested_template)
      when 1
        if @employee.update(employee_params)
          unregister_template
          register_template(requested_template)
          redirect_to employee_path(@employee), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
        else
          render :edit
        end
      when -1
        flash[:error] = l(:not_availability_template)
        render :edit
      else
        if @employee.update(employee_params)
          redirect_to employee_path(@employee), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
        else
          render :edit
        end
      end
    elsif params[:employee][:active] == '1'
      activate_employee(requested_template)
    elsif @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
    else
      render :edit
    end
  end


  def create
    @employee = Employee.new(employee_params)
    temp_by_dep = EmployeeTemplateByDepartment.find_by(department_id: @employee.department_id,
                                                       employee_template_id: @employee.employee_template_id)
    if availability_of_template(temp_by_dep)
      if @employee.save
        register_template(temp_by_dep)
        redirect_to employee_path(@employee), notice: "#{l(:label_employee)} #{l(:successfully_created)}"
      else
        render :new
      end
    else
      flash[:error] = l(:not_availability_template)
      render :new
    end
  end

  def destroy
    unregister_template if @employee.active
    @employee.destroy
    redirect_to employees_path, notice: "#{l(:label_employee)} #{l(:successfully_delete)}"
  end

  def deactivate_employee
    if @employee.update_attribute(:active, false)
      unregister_template
      redirect_to employees_path, notice: "#{l(:label_employee)} #{l(:successfully_deactivate)}"
    else
      redirect_to employees_path, notice: "#{l(:successfully_deactivate)}"
    end
  end

  def show_avatar
    employee = Employee.find(params[:id])
    image = employee.avatar
    send_data(image[:data],
              filename: image[:name],
              type: image[:content_type],
              disposition: 'inline')
  end

  private

  def activate_employee(requested_template)
    if availability_of_template(requested_template)
      if @employee.update(employee_params)
        register_template(requested_template)
        redirect_to employee_path(@employee), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
      else
        render :edit
      end
    else
      flash[:error] = l(:not_availability_template)
      render :edit
    end
  end

  def limit_per_page_option
    @limit = per_page_option
  end

  def find_employee
    @employee = Employee.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_current_template
    @current_template = EmployeeTemplateByDepartment.find_by(department_id: @employee.department_id, employee_template_id: @employee.employee_template_id)
  end

  def employee_params
    params.require(:employee).permit(:name, :ni, :race, :email, :telephone, :birthday, :contract_type_id,
                                     :active, :gender, :salary_card, :job_init_date, :employee_template_id,
                                     :department_id, :job_due_date, :address, :comments, :workweek_length, :avatar, :image)
  end

  def build_pdf
    date = fix_date(Date.today)
    html = render_to_string(template: 'employees/index.pdf.erb',
                            layout: false,
                            encoding: 'utf8',
                            locals: { employees: @employees, date: date })
    pdf = WickedPdf.new.pdf_from_string(html, orientation: 'Landscape')
    send_data(pdf, filename: l(:organization_employee_submenu) + '.pdf', disposition: 'inline',
              margin: { left: 200, right: 0 })
  end

  def fix_date(date)
    { month: month_name(date.month),
     year: date.year,
     day: date.day }
  end

end
