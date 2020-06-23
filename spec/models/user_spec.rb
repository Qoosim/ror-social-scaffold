require('rails_helper')

RSpec.describe(User, type: :model) do
  before(:each) do
    @user1 = User.create(name: 'Sender', email: 'sender@gmail.com', password: 'password')
    @user2 = User.create(name: 'Reveiver', email: 'receiver@gmail.com', password: 'password')
  end

  context 'ActiveRecord Associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
    it { should have_many(:friendships) }
    it { should have_many(:inverted_friendships) }
    it { should have_many(:confirmed_friendships) }
    it { should have_many(:friends) }
    it { should have_many(:pending_friendships) }
    it { should have_many(:pending_friends) }
    it { should have_many(:friend_requests) }
  end

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(20) }
  end

  context 'User Interactions with friendship' do
    scenario 'friend request sent' do
      @user1.friendships.build(friend: @user2, confirmed: false).save
      expect(@user2.friend_requests).not_to(be(nil))
    end

    scenario 'friend request received' do
      @user1.friendships.build(friend: @user2, confirmed: false).save
      expect(@user1.friend_requests).to_not(be(nil))
    end
  end

  context 'User content creation' do
    scenario 'user can create posts' do
      @user1.posts.build(content: 'This is just for a test').save
      expect(@user1.posts).not_to(be(nil))
    end

    scenario 'user can like posts' do
      @user1.posts.build(content: 'This is just for a test').save
      @user1.likes.create(post_id: 1)
      expect(@user1.likes.first.user_id).to(be_kind_of(Integer))
    end

    scenario 'user can comment on posts' do
      @user1.posts.build(content: 'This is my first post').save
      @user1.comments.create(post_id: 1)
      expect(@user1.comments.first.user_id).to_not(be(nil))
    end
  end
end
