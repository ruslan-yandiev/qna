require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:url) { 'http://google.com' }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds valid link when asks question' do
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'Ask'
    
    within('.question-links') do
      expect(page).to have_link 'My url', href: url
      expect(page).to_not have_selector 'script', visible: false, count: 1
    end
  end

  scenario 'User adds invalid link when asks question' do
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: 'google'

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to_not have_link 'My url', href: 'google'
  end

  scenario 'User adds valid gist link when asks question' do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    within('.question-links') do
      expect(page).to have_selector 'script', visible: false, count: 1
      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end
end