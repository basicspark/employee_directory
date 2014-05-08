class SessionsController < ApplicationController

  # GET /sessions/new
  def new
  end

  # POST /sessions
  def create
    # Find the user and attempt to log in
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to root_url
    else
      # Stay on the Login page and display an error upon login failure
      flash[:error] = "Incorrect username/password combination. Please try again."
      redirect_to login_url
    end

  end

  # DELETE /sessions/1
  def destroy
    log_out
    redirect_to root_url
  end
end
