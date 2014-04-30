class UsersController < ApplicationController
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
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        flash[:success] = 'User was successfully created.'
        format.html { redirect_to @user }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to @user }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to users_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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

    # Require a login for some actions
    def logged_in_user
      redirect_to login_url, notice: 'Please log in.' unless logged_in?
    end

    # Require an admin user for some actions
    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def get_users
      @users = User.paginate(page: params[:page])
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
