class UsersController < ApplicationController
  include SessionsHelper
  before_action :signed_in_user, only: [:index,:edit, :update, :destroy, :following, :followers, :notice]
  before_action :correct_user,   only: [:edit, :update, :notice]
  before_action :admin_user,    only: :destroy
  before_action :destroy_themself, only: :destroy
  before_action :already_has_account,   only: [:new, :create]

  def index 
    @users = User.search(params[:search]).paginate(page: params[:page], :per_page => 10)
  end

  def new
  	@user = User.new
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def microposts
    @user = User.find(params[:id])
    @microposts = @user.microposts
    @title = "#{@user.name} posts"
    @updated = @microposts.first.updated_at unless @microposts.empty?

    respond_to do |format|
      format.atom { render :layout => false }
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.send_activation_url(@user).deliver
      flash[:success] = "You will recive activation url on mail, please check it and follow"
      redirect_to root_url
  	else
  	  render 'new'
    end
  end

  def activate
    @user = User.find_by_activation_token!(params[:id])

    if @user.activation_token_sent_at < 2.days.ago
      flash[:error] = "Activation has been expired"
      redirect_to signin_path
    elsif @user.activate!
      flash[:success] = "User has been activated!"
      sign_in @user
      redirect_to @user
    else
      flash[:error] = "User could not be activated!"
      redirect_to signin_path
    end 
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def notice
    @user = User.find(params[:id])
     respond_to do |format|
      if @user.update_attribute(:not_notice, params[:not_notice])
        if params[:not_notice] == 'true'
          @message = "You will not recive message when user follow"
        else
          @message = "You will recive notice when user follow"
        end
        flash[:success] = @message
        format.html { redirect_to @user, :notice => @message }
        format.js {}
      else
        @message = "Your changes not updated"
        flash[:error] = @message
        format.html { redirect_to @user, :notice => @message  }
        format.js {}
      end
    end 
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def destroy_themself
      redirect_to(root_url) if current_user == User.find(params[:id])
    end

    def already_has_account
      redirect_to(root_url) if current_user
    end

end
