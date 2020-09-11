require 'rails_helper'

feature 'Authenticated user can see list of his rewards' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:rewards) { create_list(:reward, 3, question: question, user: user) }

  background do
    visit new_user_session_path
    sign_in(user)
  end

  scenario 'User views his rewards list' do
    visit rewards_path

    rewards.each do |reward|
      expect(page).to have_content reward.title
      expect(page).to have_content reward.question.title
    end
  end
end