class EmployeeDiseasesController < ApplicationController
  before_action :require_login
  before_action :find_disease, only: %i[edit_disease update_disease destroy]
  before_action :find_employee, only: %i[create_disease update_disease new_disease edit_disease]
  before_action :authorize_global
  include EmployeeHelper
  include SortHelper

  def edit_disease
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_disease
    @disease = EmployeeDisease.new
  end

  def update_disease
    if @disease.update(disease_params)
      respond_to do |format|
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'edit_disease',
                 id: params[:id],
                 ds_id: params[:ds_id]
        end
        format.js do
          render action: 'edit_disease',
                 id: params[:id],
                 ds_id: params[:ds_id]
        end
      end
    end
  end

  def create_disease
    @disease = EmployeeDisease.new(disease_params)
    @disease.employee_id = params[:id]
    if @disease.save
      respond_to do |format|
        format.html do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
          redirect_to employee_path(@employee)
        end
        format.js do
          flash[:notice] = "#{l(:label_employee)} #{l(:successfully_updated)}"
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: 'new_disease',
                 id: params[:id]
        end
        format.js do
          render action: 'new_disease',
                 id: params[:id]
        end
      end
    end
  end

  def destroy
    @disease.destroy
    redirect_to employee_path(params[:id]), notice: "#{l(:label_employee)} #{l(:successfully_updated)}"
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def find_disease
    @disease = EmployeeDisease.find(params[:ds_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def disease_params
    params.require(:employee_disease).permit(:name, :description)
  end
end
