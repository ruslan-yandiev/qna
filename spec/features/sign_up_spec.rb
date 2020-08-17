
require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an authenticated user
  I`d like to be able to sign up
} do

  given(:user) { create(:user) }

  scenario 'Unregistered user tries to sign up' do
    sign_up('user@test.com', '12345678', '12345678')

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with error' do
    sign_up('', '1', '123')

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_content "Password is too short (minimum is 6 characters)"
  end

  scenario 'Registered user tries to sign up' do
    sign_up(user)

    expect(page).to have_content 'Email has already been taken'
  end
end