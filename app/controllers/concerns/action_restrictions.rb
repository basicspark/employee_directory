module ActionRestrictions
  extend ActiveSupport::Concern

  private

    def logged_in_user
      redirect_to login_url, notice: 'Please log in.' unless logged_in?
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end