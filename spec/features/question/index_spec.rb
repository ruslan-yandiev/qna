require 'rails_helper'

feature 'User can view a list of questions' do
  
  given!(:questions) { create_list(:question, 3) }

  scenario 'Anyone can view the list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end