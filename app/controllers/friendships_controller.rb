class FriendshipsController < ApplicationController

  def create
    @friend = User.find(params[:friend_id] ||= params[:index_id])
    if current_user.friendships.build(friend_id: @friend.id).save
      redirect_back(fallback_location: root_path, notice: 'Friend request sent')
    else
      redirect_to current_user, alert: 'Friend Request Not Sent'
    end
  end

  def index
    @friendships = current_user.friendships
    @friend_requests = current_user.inverse_friendships
  end

  def confirm
    friendship = Friendship.find(params[:id])
    friendship.confirm_friend
    redirect_back(fallback_location: root_path, notice: 'Now you are friends')
  end

  def destroy
    if params[:id]
      Friendship.find(params[:id]).destroy
    else
      friendship = Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id])
      friendship.destroy_friendship
    end
    redirect_back(fallback_location: root_path, alert: 'Friend request declined')
  end
end
