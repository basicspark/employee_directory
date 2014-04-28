module UsersHelper

  def user_form_legend
    # Return an appropriate legend name depending on the current action
    case action_name
      when 'new', 'create'
        'Create User'
      when 'edit', 'update'
        'Edit User'
      else
        'User Maintenance'
    end
  end

end
