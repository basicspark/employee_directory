module DepartmentsHelper
  def form_legend
    # Return an appropriate legend name depending on the current action
    case action_name
      when 'new', 'create'
        'Create Department'
      when 'edit', 'update'
        'Edit Department'
      else
        'Department Maintenance'
    end
  end
end
