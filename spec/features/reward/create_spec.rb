require 'rails_helper'

feature 'User can create reward for best answer' do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'Author can add reward when create question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Reward title', with: 'My reward'
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
    end
  end
end