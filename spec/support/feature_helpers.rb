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

  def sign_up(*params)
    if params[0].class == String
      user = User.new(email: params[0], password: params[1], password_confirmation: params[2])
    else
      user = params[0]
    end

    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
  end
end