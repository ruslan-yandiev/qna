require 'rails_helper'

feature 'User can delete answer' do
  given(:author) { create(:author) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'Author can delete answer' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Answer succesfully deleted'
      expect(page).to_not have_content answer.body
    end

    scenario 'Not the author can not delete the answer' do
      sign_in(user)
      visit question_path(question)
      
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unregistered user cannot delete the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end