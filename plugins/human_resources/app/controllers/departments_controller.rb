class DepartmentsController < ApplicationController
  before_action :require_login
  before_action :find_department, only: %i[edit update show destroy]
 # before_action :verify_employees_in_tree, only: %i[destroy]
  before_action :authorize_global

  helper :departments
  include DepartmentsHelper
 # helper :wicked_pdf
  # include WickedPdfHelper

  def index
    @department_count = Department.all.count
    @limit = per_page_option
    @department_pages = Paginator.new @department_count, @limit, params['page']
    @offset ||= @department_pages.offset
    @departments = Department.all.limit(@limit).offset(@department_pages.offset)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def department_summary
    if params[:department_id].present?
      department = Department.find(params[:department_id])
      @departments = department.all_childs.to_a
      @departments << department
    else
      @departments = Department.all
    end
    respond_to do |format|
      format.html
      format.pdf(&method(:build_pdf))
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def show; end

  def edit; end

  def new
    @department = Department.new
  end

  def update
    if @department.update(department_params)
      redirect_to departments_path, notice: "#{l(:label_department)} #{l(:successfully_updated)}"
    else
      render :edit
    end
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path, notice: "#{l(:label_department)} #{l(:successfully_created)}"
    else
      render :new
    end
  end

  def destroy
    if verify_employees_in_tree
      redirect_to departments_path
      flash[:error] = "#{l(:label_department)} #{l(:unsuccessfully_delete)} #{l(:employee_dependent_error)}"
    elsif @department.destroy
      redirect_to departments_path, notice: "#{l(:label_department)} #{l(:successfully_delete)}"
    else
      redirect_to departments_path
      flash[:error] = "#{l(:label_department)} #{l(:unsuccessfully_delete)} #{l(:employee_dependent_error)}"
    end
  end


  private

  def limit_per_page_option
    @limit = per_page_option
  end

  def find_department
    @department = Department.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def department_params
    params.require(:department).permit(:name, :description, :status, :parent_id)
  end

  def build_pdf
    date = fix_date(Date.today)
    html = render_to_string(template: 'departments/department_summary.pdf.erb',
                            layout: false,
                            encoding: 'utf8',
                            locals: { departments: @departments, date: date })
    pdf = WickedPdf.new.pdf_from_string(html, orientation: 'Landscape')
    send_data(pdf, filename: l(:label_annex_14) + '.pdf', disposition: 'inline',
              margin: { left: 200, right: 0 })
  end

  def fix_date(date)
    { month: month_name(date.month),
      year: date.year,
      day: date.day }
  end
end
