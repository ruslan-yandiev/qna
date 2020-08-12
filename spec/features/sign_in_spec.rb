
require 'rails_helper'

# Описание теста в виде (аналогично) истории пользователя, и расширенное описание после запятой(опционально)
feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I`d like to be able to sign in
} do
  
  # элиас метода let и как и он без ! будет ленивым, используется в фича тестах
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }

  # элиас before но в фича тестах используется background
  background do
    # укажем хелпер маршрута new_user_session либо '/users/sign_in' созданный gem 'devise' 
    visit new_user_session_path
  end

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # универсальный хелпер умеющий кликать и по кнопкам и по ссылкам
    click_on 'Log in'

    # # для использования нужно поставить gem 'launchy'
    # # команда позволяет сохранять и открытвать страницу, вставляем в строку где возникла ошибка, облегчит понимание
    # # позволяет посмотреть и понять почему не проходит тест(к примеру кнопка по другому называется), что там на странице происходит не запуская rails сервера (отладка)
    # save_and_open_page

    # 'Signed in successfully.' в нашем случе укажем в качестве ожидаемого результата сообщение которое вернет gem 'devise'
    expect(page).to have_content 'Signed in successfully.'
  end
  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end