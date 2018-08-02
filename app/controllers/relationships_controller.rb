class RelationshipsController < ApplicationController
  # ページ表示前にログインユーザーか確認し、未ログインの場合ログインページに飛ばす
  before_action :logged_in_user

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end
end
