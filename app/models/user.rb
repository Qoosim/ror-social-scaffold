class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, foreign_key: 'user_id', dependent: :destroy
  # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  # Users who requested to be friends (needed for notifications )
  has_many :inverted_friendships, -> { where confirmed: true }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friends_requests, through: :inverted_friendships

  # Users who need to confirm friendship
  has_many :pending_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  # Find user friends only by user_id from friendship table
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  def friends_and_own_posts
    Post.where(user: (friend + self))
  end

  # Users who have yet to confirm friend requests
  def pending_friend?(user)
    friend_requests.include?(user)
  end

  # Users who have requested to be friends
  def friend_requests
    inverted_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  # Method to check if a given user is a friend
  def friend?(user)
    friends.include?(user)
  end
end
