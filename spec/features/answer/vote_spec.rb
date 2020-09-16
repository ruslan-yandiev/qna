require 'rails_helper'

feature 'User can vote for answer to the question' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote for not own answer', js: true do
      within "#vote-Answer-#{answer2.id}" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'

        expect(page).to have_content answer2.all_likes
      end
    end

    scenario 'votes up for not own answer', js: true do
      within "#vote-Answer-#{answer2.id}" do
        click_on '+'

        expect(page).to have_content answer2.all_likes
      end
    end

    scenario 'votes down for not own answer', js: true do
      within "#vote-Answer-#{answer2.id}" do
        click_on '-'

        expect(page).to have_content answer2.all_likes
      end
    end

    scenario 'can not to vote for own answer', js: true do
      within "#vote-Answer-#{answer.id}" do

        expect(page).not_to have_link '+'
        expect(page).not_to have_link '-'
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for an answer to the question' do
    visit question_path(question)

    within "#vote-Answer-#{answer2.id}" do
      expect(page).not_to have_link '+'
      expect(page).not_to have_link '-'
    end
  end
end