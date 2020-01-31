class EmployeeTemplateCategoriesController < ApplicationController
  before_action :require_login
  before_action :find_template_category, only: %i[update edit destroy]
  before_action :authorize_global
  def index
    @template_categories = EmployeeTemplateCategory.all
  end

  def edit; end

  def new
    @template_category = EmployeeTemplateCategory.new
  end

  def update
    if @template_category.update(template_categories_params)
      redirect_to employee_template_categories_path, notice: "#{l(:successfully_updated)}"
    else
      render :edit
    end
  end

  def create
    @template_category = EmployeeTemplateCategory.new(template_categories_params)
    if @template_category.save
      redirect_to employee_template_categories_path, notice: "#{l(:successfully_created)}"
    else
      render :new
    end
  end

  def destroy
    @template_category.destroy
    redirect_to employee_template_categories_path, notice: "#{l(:successfully_delete)}"
  end

  private

  def find_template_category
    @template_category = EmployeeTemplateCategory.find(params[:id])
  end

  def template_categories_params
    params.require(:employee_template_category).permit(:name, :alias, :description)
  end
end
