module ApplicationHelper

  def active_class_for(menu_item)
    # Returns 'active' for navbar active state depending on menu and
    # current Controller and Action
    case menu_item
      when :home
        return 'active' if controller_name == 'users' && action_name == 'index'
      when :profile
        return 'active' if controller_name == 'users' && action_name == 'edit'
      when :maintenance
        return nil
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
end
