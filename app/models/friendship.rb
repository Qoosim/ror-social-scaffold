class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  # Confirms friendship
  def confirm_friend
    update_attributes(confirmed: true)
    Friendship.create!(
      friend_id: user_id,
      user_id: friend_id,
      confirmed: true
    )
  end

  # Destroy friendship on friended users
  def destroy_friendship
    friendship = Friendship.where(user_id: user_id, friend_id: friend_id).take
    inverted_friendships = Friendship.where(user_id: friend_id, friend_id: user_id).take
    friendship&.delete
    inverted_friendships&.delete
  end
end
