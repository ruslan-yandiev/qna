require 'rails_helper'

feature 'User can create answer', %q{
  In order to create answer from a question
  As an unauthenticated user
  I`d like to be able to aks the question
} do

  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer to a question' do
      fill_in 'Body', with: 'text text text'
      click_on 'create'

      expect(page).to have_content 'Your answer succesfully created'
      expect(page).to have_content "text text text"
    end

    scenario 'create an answer with error' do
      click_on 'create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user creates an answer to the question' do
    visit question_path(question)
    click_on 'create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end