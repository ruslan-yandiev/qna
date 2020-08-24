require 'rails_helper'

feature 'User can edit his question', "
  In order to edit a question
  As an authenticated user
  I'd like to be able to edit my own question
" do
  given!(:author) { create(:author) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    background do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'edits his question', js: true do
      within '.question' do
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        
        click_on 'Save question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      within '.question' do
        fill_in 'Title', with: ''

        click_on 'Save question'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'edit the question and add files', js: true do
      within '.question' do
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save question'

        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario "tries to edit other user`s question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit question'
    end
  end
end