require "rails_helper"

feature 'User tries to delete file for question', js: true do
  given!(:author) { create(:author) }
  given!(:question) { create(:question, :with_file, user: author)}

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'Author can delete file' do
      sign_in(author)
      visit question_path(question)

      click_on 'Delete file'

      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'Not the author can not delete the file' do
      sign_in(user)
      visit question_path(question)
      
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Unregistered user cannot delete the file' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end