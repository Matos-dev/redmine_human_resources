class EmployeeTemplatesController < ApplicationController
  before_action :require_login
  before_action :find_employee_template, only: %i[edit update show destroy]
  before_action :authorize_global
  include EmployeeTemplateQueryHelper
  helper :employee_template_query
  include SortHelper
  helper :sort
  include QueriesHelper
  helper :queries
  include EmployeeNomenclatorsHelper
  helper :employee_nomenclators

  def index
    retrieve_details_query('employee_template')
    sort_init(@query.sort_criteria.empty? ? [%w[name desc]] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a
    if @query.valid?
      @limit = per_page_option

      @employee_templates_count = @query.object_count
      @employee_templates_scope = @query.objects_scope

      @employee_templates_pages = Paginator.new @employee_templates_count, @limit, params['page']
      @offset ||= @employee_templates_pages.offset

      @employee_templates = @query.results_scope(
        search: params[:search],
        order: sort_clause,
        limit: @limit,
        offset: @offset
      )
      @employee_templates_count_by_group = @query.detail_count_by_group
      respond_to do |format|
        format.html
        format.pdf {build_pdf}
      end
    else
      respond_to do |format|
        format.html {render(template: 'employee_templates/index', layout: !request.xhr?)}
        format.any(:csv, :pdf) {render(nothing: true)}
        format.api {render_validation_errors(@query)}
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def show; end

  def edit; end

  def new
    @employee_template = EmployeeTemplate.new
  end

  def update
    @employee_template.employee_education_level_ids = params[:employee_template]['employee_education_level_ids']
    if @employee_template.update(employee_template_params)
      redirect_to employee_templates_path, notice: "#{l(:label_employee_template)} #{l(:successfully_updated)}"
    else
      render :edit
    end
  end

  def create
    @employee_template = EmployeeTemplate.new(employee_template_params)
    @employee_template.employee_education_level_ids = params[:employee_template]['employee_education_level_ids']
    if @employee_template.save
      redirect_to employee_templates_path, notice: "#{l(:label_employee_template)} #{l(:successfully_created)}"
    else
      render :new
    end
  end

  def destroy
    if @employee_template.destroy
      redirect_to employee_templates_path, notice: "#{l(:label_employee_template)} #{l(:successfully_delete)}"
    else
      redirect_to employee_templates_path
      flash[:error] = "#{l(:label_employee_template)} #{l(:unsuccessfully_delete)} #{l(:employee_dependent_error)}"
    end
  end

  private

  def limit_per_page_option
    @limit = per_page_option
  end

  def find_employee_template
    @employee_template = EmployeeTemplate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def employee_template_params
    params.require(:employee_template).permit(:name, :mission, :rga_template,
                                              :functions, :responsibilities, :sociological_profile,
                                              :occupational_profile, :relationships,
                                              :template_category_id, :salary_scale_id,
                                              :employee_education_level_ids)
  end
end
