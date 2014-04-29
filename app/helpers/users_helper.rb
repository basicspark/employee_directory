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

  def non_admin_disable
    # Return true for disabled flag on certain fields non-admins can't edit
    !current_user.admin?
  end

end
