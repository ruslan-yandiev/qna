module FeatureHelpers
  def sign_in(user)
    # укажем хелпер маршрута new_user_session либо '/users/sign_in' созданный gem 'devise'
    visit new_user_session_path
    # fill_in, click_on DSL гема capybara
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # универсальный хелпер умеющий кликать и по кнопкам и по ссылкам
    click_on 'Log in'
  end
end