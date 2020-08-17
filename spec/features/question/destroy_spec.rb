require 'rails_helper'

feature 'User can delete question' do
  given(:author) { create(:author) }
  given(:question) { create(:question, user: author)}

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'Author can delete question' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question succesfully deleted'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'Not the author can not delete the question' do
      sign_in(user)
      visit question_path(question)
      
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unregistered user cannot delete the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end