require 'rails_helper'

feature 'User can create answer', %q{
  In order to create answer from a question
  As an unauthenticated user
  I`d like to be able to aks the question
} do

  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer to a question' do
      fill_in 'Body', with: 'text text text'
      click_on 'create'

      # проверяем, что мосле создания ответа мы остались на той же странице вопроса и нас не перекинуло
      expect(current_path).to eq question_path(question)

      # expect(page).to have_content 'Your answer succesfully created'

      # within ограничивает область страницы в которой делаем проверку
      within '.answers' do # Чтобы убедиться, что ответ в списке в div с классом answers, а не в форме
        expect(page).to have_content "text text text"
      end
    end

    scenario 'create an answer with error' do
      click_on 'create'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can reply and attach a file' do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user creates an answer to the question' do
    visit question_path(question)
    click_on 'create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end