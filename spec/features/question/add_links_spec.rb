require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:url) { 'http://google.com' }
  given(:url2) { 'http://yandex.com' }

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

  scenario 'User adds valid link when asks question and user can add another link', js: true do
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'Ask'
    
    within('.question-links') do
      expect(page).to have_link 'My url', href: url
    end

    click_on 'Edit question'

    find('.button-add-question-link').click

    find_field(id: 'question_links_attributes_1_name').fill_in(with: 'My url2')
    find_field(id: 'question_links_attributes_1_url').fill_in(with: url2)

    click_on 'Save question'

    within('.question-links') do
      expect(page).to have_link 'My url2', href: url2
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