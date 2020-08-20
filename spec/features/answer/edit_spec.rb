require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I`d like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:author) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(author)
      visit question_path(question)
      # save_and_open_page
      click_on 'Edit'

      within '.answers' do # проверки ограничены блоком div с классом = answers
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        # проверим, что у нас нет старого содержимого ответа
        expect(page).to_not have_content answer.body

        expect(page).to have_content 'edited answer'

        # проверим, что форма с редактированием ответа исчезла
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(author)
      visit question_path(question)
      
      within ".answers" do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      # save_and_open_page
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit other user`s question', is: true do
      sign_in(user)
      visit question_path(question)
      
      expect(page).to_not have_link 'Edit'
    end
  end
end