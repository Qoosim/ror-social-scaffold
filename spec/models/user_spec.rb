require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user_1 = User.create(name: 'Sender', email: 'sender@gmail.com', password: 'password')
    @user_2 = User.create(name: 'Reveiver', email: 'receiver@gmail.com', password: 'password')
  end

  context 'ActiveRecord Associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
    it { should have_many(:friendships) }
    it { should have_many(:inverse_friendships) }
    it { should have_many(:confirmed_friendships) }
    it { should have_many(:friends) }
    it { should have_many(:pending_friendships) }
    it { should have_many(:pending_friends) }
    it { should have_many(:friends_requests) }
  end

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(20) }
  end

  context 'User Interactions with friendship' do
    scenario 'friend request sent' do
      @user_1.friendships.build(friend: @user_2, confirmed: false).save
      expect(@user_2.friend_requests).not_to be(nil)
    end

    scenario 'friend request received' do
      @user_1.friendships.build(friend: @user_2, confirmed: false).save
      expect(@user_1.friend_requests).to_not be(nil)
    end
  end

  context 'User content creation' do
    scenario 'user can create posts' do
      @user_1.posts.build(content: 'This is just for a test').save
      expect(@user_1.posts).not_to be(nil)
    end

    scenario 'user can like posts' do
      @user_1.posts.build(content: 'This is just for a test').save
      @user_1.likes.create(post_id: 1)
      expect(@user_1.likes.first.user_id).to be_kind_of(Integer)
    end

    scenario 'user can comment on posts' do
      @user_1.posts.build(content: 'This is my first post').save
      @user_1.comments.create(post_id: 1)
      expect(@user_1.comments.first.user_id).to_not be(nil)
    end
  end

end