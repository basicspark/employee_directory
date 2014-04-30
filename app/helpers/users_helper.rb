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

  def gravatar_for(user, options={ size: 150 })
    # Returns the Gravatar for the provided user
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.first_name + ' ' + user.last_name,
              class: 'user-gravatar')
  end


end
