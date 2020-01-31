module EmployeeNomenclatorsHelper
  def retrieve_education_levels
    EmployeeEducationLevel.all.select(:id, :name)
  end

  def retrieve_contract_types
    EmployeeContractType.all.select(:id, :name)
  end

end
