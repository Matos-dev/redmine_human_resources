# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :employees
resources :departments
resources :employee_templates
resources :employee_template_categories
resources :employee_education_levels
resources :employee_salary_scales
resources :employee_contract_types
get 'employee/:id/show_avatar', to: 'employees#show_avatar'
post 'employee/:id/deactivate_employee', to: 'employees#deactivate_employee'
get 'employees/department_tree/summary', to: 'departments#department_summary'
# routes for employee_work_experiences
get 'employee/:id/new_experience', to: 'employee_work_experiences#new_experience'
post 'employee/:id/create_experience', to: 'employee_work_experiences#create_experience'
get 'employee/:id/edit_experience/:wexp_id', to: 'employee_work_experiences#edit_experience'
match 'employee/:id/edit_experience/:wexp_id', to: 'employee_work_experiences#update_experience', via: [:put, :patch]
delete 'employee/:id/destroy_experience/:wexp_id', to: 'employee_work_experiences#destroy'
# routes for employee_educationals
get 'employee/:id/new_educational_data', to: 'employee_educationals#new_educational_data'
post 'employee/:id/create_educational_data', to: 'employee_educationals#create_educational_data'
get 'employee/:id/edit_educational_data/:edu_id', to: 'employee_educationals#edit_educational_data'
match 'employee/:id/edit_educational_data/:edu_id', to: 'employee_educationals#update_educational_data', via: [:put, :patch]
delete 'employee/:id/destroy_educational_data/:edu_id', to: 'employee_educationals#destroy'
# routes for employee_diseases
get 'employee/:id/new_disease', to: 'employee_diseases#new_disease'
post 'employee/:id/create_disease', to: 'employee_diseases#create_disease'
get 'employee/:id/edit_disease/:ds_id', to: 'employee_diseases#edit_disease'
match 'employee/:id/edit_disease/:ds_id', to: 'employee_diseases#update_disease', via: [:put, :patch]
delete 'employee/:id/destroy_disease/:ds_id', to: 'employee_diseases#destroy'
# routes for employee_salary_key
get 'employee/:id/new_salary_key', to: 'employee_salary_keys#new_salary_key'
post 'employee/:id/create_salary_key', to: 'employee_salary_keys#create_salary_key'
get 'employee/:id/edit_salary_key/:sk_id', to: 'employee_salary_keys#edit_salary_key'
match 'employee/:id/edit_salary_key/:sk_id', to: 'employee_salary_keys#update_salary_key', via: [:put, :patch]
delete 'employee/:id/destroy_salary_key/:sk_id', to: 'employee_salary_keys#destroy'
# routes for employee_training
get 'employee/:id/new_training', to: 'employee_trainings#new_training'
post 'employee/:id/create_training', to: 'employee_trainings#create_training'
get 'employee/:id/edit_training/:training_id', to: 'employee_trainings#edit_training'
match 'employee/:id/edit_training/:training_id', to: 'employee_trainings#update_training', via: [:put, :patch]
delete 'employee/:id/destroy_training/:training_id', to: 'employee_trainings#destroy'
# routes for employee_templates_by_department
get 'department/:id/templates/edit', to: 'employee_template_by_department#edit_template_by_department'
post 'department/:id/templates/manage_templates', to: 'employee_template_by_department#update_template_by_department'