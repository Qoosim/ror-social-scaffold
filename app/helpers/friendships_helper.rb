module FriendshipsHelper
  def friend_show_btn(id = nil)
    params[:index_id] = id if id
    @viewed_user = User.find(params[:index_id] ||= params[:id])

    if current_user.pending_friend?(@viewed_user)
      link_to('Confirm Friend Request', friendships_path)
    elsif @viewed_user.pending_friend?(current_user)
      link_to(
        'Friend request is waiting for acceptance. Decline the request',
        notfriend_path(user_id: current_user, friend_id: params[:index_id] ||= params[:id]),
        method: :delete
      )
    elsif !current_user.pending_friend?(@viewed_user)
      friend_notfriend_btn
    end
  end

  def friend_notfriend_btn
    if current_user.friend?(@viewed_user)
      link_to(
        'Cancle friendship',
        notfriend_path(
          user_id: current_user,
          friend_id: params[:index_id] ||= params[:id]
        ),
        method: :delete
      )
    else
      link_to(
        'Send friend request',
        user_friendships_path(user_id: current_user, friend_id: params[:index_id]),
        method: :post
      )
    end
  end

  def confirm_btn(frd)
    link_to(
      'Confirm Friendship Request',
      confirm_path(id: frd.id, iduser_id: frd.user_id, friend: frd.friend_id),
      method: :patch
    )
  end

  def decline_btn(frd)
    link_to(
      'Decline Friendship Request',
      notfriend_path(id: frd.id, user_id: frd.user_id, friend_id: frd.friend_id),
      method: :delete
    )
  end
end
