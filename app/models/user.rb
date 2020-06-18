class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, dependent: :destroy
  # has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  # Users who requested to be friends (needed for notifications )
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverted_friendships

  # Users who need to confirm friendship
  has_many :pending_friendships, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :user

  # Find user friends only by user_id from friendship table 
  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friends, through: :confirmed_friendships
  

  def friends_and_own_posts
    Post.where(user: (self.friend + self))
  end

  # Users who have yet to confirm friend requests
  def pending_friend?(user)
    friend_requests.include?(user)
  end

  # Method to check if a given user is a friend
  def friend?(user)
    friends.include?(user)
  end
end
