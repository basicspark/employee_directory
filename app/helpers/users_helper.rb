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

  def view_option_check_for(option, param)
    if option == 'all' && param[:user_filter_type] == 'all'
      true
    elsif option == 'dep' && param[:user_filter_type] == 'dep'
      true
    elsif option == 'all' && param[:user_filter_type] == nil
      true
    else
      false
    end
  end

  def filter_panel_class_for(collapsed = false)
    if collapsed
      "visible-xs visible-sm"
    else
      "visible-md visible-lg"
    end
  end

  def filter_panel_title_for(title, collapsed = false)
    if collapsed
      output = "<a data-toggle='collapse' href='#collapseOne'>"
      output += title + "<b class='caret'></b></a>"
      output.html_safe
    else
      title
    end
  end

  def filter_panel_body_for(collapsed = false, &block)
    if collapsed
      content_tag(:div, capture(&block), id: 'collapseOne',
                  class: 'panel-collapse collapse')
    else
      capture(&block)
    end
  end
end
