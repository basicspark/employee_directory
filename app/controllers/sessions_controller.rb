class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to users_path
    else
      # Stay on the Login page and display an error
      flash.now[:error] = "Incorrect username/password combination. Please try again."
      render 'new'
    end

  end

  def destroy
    log_out
    redirect_to users_path
  end
end
