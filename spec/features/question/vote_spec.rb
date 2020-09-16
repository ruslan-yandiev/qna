require 'rails_helper'

feature 'User can vote for the question' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question2)
    end

    scenario 'can vote for not own question', js: true do
      expect(page).to have_link '+'
      expect(page).to have_link '-'
      
      expect(page).to have_content question2.all_likes
    end

    scenario 'votes up for not own question', js: true do
      within "#vote-Question-#{question2.id}" do
        click_on '+'

        expect(page).to have_content question2.all_likes
      end
    end

    scenario 'votes down for not own question', js: true do
      within "#vote-Question-#{question2.id}" do
        click_on '-'

        expect(page).to have_content question2.all_likes
      end
    end

    scenario 'can not to vote for own question', js: true do
      visit question_path(question)

      expect(page).not_to have_link '+'
      expect(page).not_to have_link '-'

      expect(page).to have_content question.all_likes
    end
  end

  scenario 'An unauthenticated user tries to vote on a question' do
    visit question_path(question)

    expect(page).not_to have_link '+'
    expect(page).not_to have_link '-'

    expect(page).to have_content question.all_likes
  end
end