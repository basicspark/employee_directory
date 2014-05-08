module ApplicationHelper

  def active_class_for(menu_item)
    # Returns 'active' for navbar active state depending on menu and
    # current Controller and Action
    case menu_item
      when :directory
        return 'active' if controller_name == 'users' &&
                           action_name == 'directory'
      when :profile
        return 'active' if controller_name == 'users' &&
                           action_name == 'edit'
      when :maintenance
        return 'active' if ((controller_name == 'departments' ||
                             controller_name == 'users') &&
                          action_name == 'index')
      when :login
        if controller_name == 'sessions' &&
           (action_name == 'new' || action_name == 'create')
          return 'active'
        end
      when :logout
        return nil
      else
        return nil
    end
  end

  def flash_class_for(type)
    case type
      when 'notice'
        'alert-info'
      when 'error'
        'alert-danger'
      when 'alert'
        'alert-warning'
      when 'success'
        'alert-success'
      else
        type.to_s
    end
  end
end
