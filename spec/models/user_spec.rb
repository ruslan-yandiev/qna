require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent :destroy }
  it { should have_many(:answers).dependent :destroy }

  # по сути раз мы используем gem 'devise' то и эти юнит тесты можно не писать
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Instance method author?' do
    let(:author) { create(:author) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

    it 'return true if the author is the creator' do
      # просто к be_ добавить без предиката (?) свой реализованный метод (author?) который мы тестируем, а предикат(?) автоматичеки подставится
      expect(author).to be_author(question)
      expect(author).to be_author(answer)
    end

    it 'return false if the user is not the creator' do
      expect(user).to_not be_author(question)
      expect(user).to_not be_author(answer)
    end
  end
end
