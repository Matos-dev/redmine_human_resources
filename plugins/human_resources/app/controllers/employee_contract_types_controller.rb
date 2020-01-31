class EmployeeContractTypesController < ApplicationController
  before_action :require_login
  before_action :find_contract_type, only: %i[edit update destroy]

  # before_action :authorize_domain_global
  def index
    @contract_types = EmployeeContractType.all
  end

  def edit; end

  def new
    @contract_type = EmployeeContractType.new
  end

  def update
    if @contract_type.update(contract_type_params)
      flash[:notice] = "#{l(:label_contract_type)} #{l(:successfully_updated)}"
      redirect_to employee_contract_types_path
    else
      render action: 'edit'
    end
  end

  def create
    @contract_type = EmployeeContractType.new(contract_type_params)
    if @contract_type.save
      flash[:notice] = "#{l(:label_contract_type)} #{l(:successfully_updated)}"
        redirect_to employee_contract_types_path(@contract_type)
    else
      render action: 'new'
    end
  end

  def destroy
    @contract_type.destroy
    redirect_to employee_contract_types_path(params[:id]), notice: "#{l(:label_contract_type)} #{l(:successfully_delete)}"
  end

  private

  def find_contract_type
    @contract_type = EmployeeContractType.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def contract_type_params
    params.require(:employee_contract_type).permit(:name, :description)
  end
end
