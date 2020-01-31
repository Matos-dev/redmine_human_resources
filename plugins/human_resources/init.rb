Redmine::Plugin.register :human_resources do
  name 'Human Resources plugin'
  author 'Eliuvis Matos Matos'
  description 'This plugin allows management humans resources'
  version '2019.02.24'
  url 'https://github.com/Matos-dev/human_resources'
  author_url 'https://github.com/Matos-dev'

  requires_redmine version_or_higher: '4.0.0'
  menu :top_menu, :label_employees,
       { controller: :employees, action: :index },
       if: proc {
         User.current.allowed_to?(
             { controller: :employees, action: :index },nil, global: true)
       },
       caption: :organization_employee_submenu,
       parent: :menu_human_resource_management

  menu :admin_menu, :admin_employee_template_categories_label,
       { controller: :employee_template_categories, action: :index },
       if: proc {
  User.current.allowed_to?(
    { controller: :employee_template_categories, action: :index }, nil, global: true)},
       caption: :admin_employee_template_categories_label,
       html: { class: 'icon', style: 'background-image: url(/plugin_assets/human_resources/images/human_resources.png)' }

  menu :top_menu, :label_departments,
       { controller: :departments, action: :index },
       if: proc {
         User.current.allowed_to?(
             { controller: :departments, action: :index },nil, global: true)
       },
       caption: :label_departments,
       parent: :menu_human_resource_management

  project_module :human_resources_module_label do
    permission :view_employees_permission_label,
               employees: %i[index show show_avatar]
    permission :edit_employees_permission_label,
               employees: %i[new create edit update]
    permission :destroy_employees_permission_label,
               employees: %i[destroy]
    permission :deactivate_employees_permission_label,
               employees: %i[deactivate_employee]

    permission :view_templates_permission_label,
               employee_templates: %i[index show]
    permission :edit_templates_permission_label,
               employee_templates: %i[new create edit update]
    permission :destroy_templates_permission_label,
               employee_templates: %i[destroy]

    permission :view_departments_permission_label,
               departments: %i[index department_summary show]
    permission :edit_departments_permission_label,
               departments: %i[new create edit update]
    permission :destroy_departments_permission_label,
               departments: %i[destroy]
    permission :managed_department_templates_permission_label,
               employee_template_by_department: %i[update_template_by_department edit_template_by_department]
  end

end