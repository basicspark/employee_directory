class UsersController < ApplicationController
  include ActionRestrictions
  before_action :logged_in_user, except: [:directory, :show]
  before_action :admin_user, except: [:directory, :edit, :update, :show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :edit_self_only, only: [:edit, :update]

  # GET /users
  def index
    get_users
  end

  def directory
    get_users
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    render :form
  end

  # GET /users/1/edit
  def edit
    render :form
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User was successfully created.'
      redirect_to @user
    else
      render :form
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
      redirect_to @user
    else
      render :form
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.js { render template: 'shared/remove_row',
                         locals: { target_object: @user } }
      format.html { redirect_to users_url }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if current_user.admin?
        # Allow admins more access
        params.require(:user).permit(:first_name, :last_name, :department_id,
                                     :phone, :email, :password, :password_confirmation,
                                     :address, :start_date, :birthday, :admin)
      else
        # Allow general users less access
        params.require(:user).permit(:phone, :email, :password, :password_confirmation,
                                     :address)
      end
    end

    def get_users
      name_to_find = params[:user_filter_string]
      dept_to_find = params[:user_filter_type] == 'dep' ? params[:user_filter_department] : nil
      @users = find_users_by_page(name_to_find, dept_to_find, params[:page])
    end

    def find_users_by_page(name, department, page)
      found_users = case
        when name && department
          # Search by both name and department
          User.with_name(name).in_department(department)
        when name && !department
          # Only search by name
          User.with_name(name)
        when !name && department
          # Only search by department
          User.in_department(department)
        else
          # No search criteria so return all
          User.all
      end
      # Return paginated result
      found_users.paginate(page: page)
    end

    def edit_self_only
      # Unless the user is an admin, they may only edit their own record
      unless current_user.admin?
        if current_user != User.find(params[:id])
          # Trying to edit someone else, so redirect to their own record
          redirect_to edit_user_url(current_user)
        end
      end
    end
end
