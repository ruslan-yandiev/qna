require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}
  given(:url) {'http://google.com'}
  given(:url2) {'http://yandex.ru'}

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'My answer'
  end

  scenario 'User adds valid link when give an answer', js: true do
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'create'

    within '.answer-links' do
      expect(page).to have_link 'My url', href: url
      expect(page).to_not have_selector 'script', visible: false, count: 1
    end
  end

  scenario 'User adds invalid link when give an answer', js: true do
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: 'google'

    click_on 'create'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to_not have_link 'My url', href: 'google'
  end

  scenario 'User adds valid gist link when give an answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'create'

    within '.answer-links' do
      expect(page).to have_selector 'script', visible: false, count: 1
      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end
end
