class UsersController < ApplicationController
  before_action :logged_in_user, except: [:directory, :index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    # get_users
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
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
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
      params.require(:user).permit(:first_name, :last_name, :department_id, :phone, :email, :address, :start_date, :birthday)
    end

    # Require a login for some actions
    def logged_in_user
      redirect_to login_url, notice: 'Please log in.' unless logged_in?
    end

    def get_users
      @users = User.paginate(page: params[:page])
    end
end
