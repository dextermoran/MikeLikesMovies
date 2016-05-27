class UsersController < ApplicationController

  def new
    @group = Group.find(params[:group_id])
    @user = User.new
    render :new
  end

  #this is for when mike creates a new user with just an email
  def create
    @user = User.new(user_params)
    @user.add_token
    @tempass = SecureRandom.hex(4)
    @user.password = @tempass
    @group = Group.find(params[:group_id])
    if @user.save
      Reviewer.create(user: @user, group: @group)
      UserMailer.invite_mailer(@user, @tempass).deliver
      redirect_to '/'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def set_password
    @user.find_by(email: params[:email])
    if params[:token] == @user.token
      @user.password = params[:password]
      @user.save
      redirect_to login_path
    else
      redirect_to root_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end
end
