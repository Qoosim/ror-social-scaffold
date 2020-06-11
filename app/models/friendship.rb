class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  # Confirms friendship
  def confirm_friend
    self.update_attributes(confirmed: true)
    Friendship.create!(friend_id: self.user_id,
                      user_id: self.friend_id, confirmed: true)

  end

  def second_row
    friend = Friendship.find(:id)
    return if Friendship.friendship.exists?(friend.friend_id, friend.user_id)
    Friendship.create(user_id: friend.friend_id, friend_id: friend.user_id)
  end

  def friendship_exists?(user_id, friend_id)
    Friendship.where(user_id: user_id, friend_id: friend_id).exists?
  end

  # Destroy friendship on friended users
  def destroy_friendship
    friendship = Friendship.where(user_id: user_id, friend_id: friend_id).take
    inverse_friendship = Friendship.where(user_id: friend_id, friend_id: user_id).take
    friendship&.delete
    inverse_friendship&.delete
  end

end
