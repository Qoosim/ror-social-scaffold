require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @friend1 = User.create(name: 'Sender', email: 'sender@gmail.com', password: 'password')
    @friend2 = User.create(name: 'Receiver', email: 'receiver@gmail.com', password: 'password')
  end

  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend) }
  end

  context 'ApplicationRecord Test' do
    scenario 'should build valid friendship' do
      @friend1.friendships.build(friend_id: @friend2.id).save
      frd = @friend1.friendships.where(user_id: @friend1.id, friend_id: @friend2.id).first
      expect(frd).to be_valid
    end

    scenario 'should confirm friendship' do
      @friend1.friendships.build(friend_id: @friend2.id).save
      frd = @friend1.friendships.where(user_id: @friend1.id, friend_id: @friend2.id).first
      frd.confirm_friend
      expect(frd.confirmed).to be(true)
    end

    scenario 'should not be valid with wrong arguments' do
      frd = Friendship.create(user_id: '', friend_id: @friend2.id)
      expect(frd.valid?).to be(false)

      frd = Friendship.create(user_id: @friend1.id, friend_id: '')
      expect(frd.valid?).to be(false)

      frd = Friendship.create(user_id: '', friend_id: '')
      expect(frd.valid?).to be(false)
    end
  end
end