require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  # по сути раз мы используем gem 'devise' то и эти юнит тесты можно не писать
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Instance method author?' do
    let(:author) { create(:author) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

    it 'return true if the author is the creator' do
      expect(author.id).to eq question.user_id
      expect(author.id).to eq answer.user_id
    end

    it 'return false if the user is not the creator' do
      expect(user.id).to_not eq question.user_id
      expect(user.id).to_not eq answer.user_id
    end
  end
end
