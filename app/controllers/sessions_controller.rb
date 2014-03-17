class SessionsController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
  	else
  	  flash.now[:error] = 'Invalid email/password combination' # Not quite right!
  	  render 'new'
    end
  end

  def destroy
  end
  private

    def user_params
  	  params.require(:session).permit(:email, :password)
    end
end