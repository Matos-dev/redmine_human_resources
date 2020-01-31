module EmployeeTemplateQueryHelper
  def retrieve_details_query(object_type)
    query_class = Object.const_get("#{object_type.camelcase}Query")
    if params[:query_id].present?
      @query = query_class.find(params[:query_id])
      raise ::Unauthorized unless @query.visible?
      @query.group_by = session["#{object_type}_query".to_sym] && session["#{object_type}_query".to_sym][:group_by] if @query.group_by.nil?
      @query.column_names = session["#{object_type}_query".to_sym] && session["#{object_type}_query".to_sym][:column_names]
      session["#{object_type}_query".to_sym] = { id: @query.id }
      sort_clear
    elsif api_request? || params[:set_filter] || session["#{object_type}_query".to_sym].nil? || session["#{object_type}_query".to_sym][:project_id] != (@project ? @project.id : nil)
      # Give it a name, required to be valid
      @query = query_class.new(name: '_')
      @query.build_from_params(params)
      session["#{object_type}_query".to_sym] = { filters: @query.filters, group_by: @query.group_by, column_names: @query.column_names }
    else
      @query = query_class.find(session["#{object_type}_query".to_sym][:id]) if session["#{object_type}_query".to_sym][:id]
      @query ||= query_class.new(name: '_', filters: session["#{object_type}_query".to_sym][:filters], group_by: session["#{object_type}_query".to_sym][:group_by], column_names: session["#{object_type}_query".to_sym][:column_names])
    end
  end
end