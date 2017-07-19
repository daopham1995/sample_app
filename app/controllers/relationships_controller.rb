class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user  = User.find_by id: params[:id]
    if @user
      @title = params[:relationship]
      @users = @user.send(@title).paginate page: params[:page]
      render "users/show_follow"
    else
      flash[:danger] = "User not exist"
      redirect_to users_path
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @active = current_user.active_relationships
        .find_by followed_id: @user.id
      unless @active
        flash[:danger] = "Can't unfollow!"
        redirect_to root_url
      end
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = "User not exist"
      redirect_to users_path
    end 
  end

  def destroy
    @relationship = Relationship.find_by id: params[:id]
    if @relationship
      @active = current_user.active_relationships.build
      @user = @relationship.followed
      current_user.unfollow @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = "Not followed user to unfollow"
      redirect_to root_url
    end
  end
end
