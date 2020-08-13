# Создавать эти хелперы(макросы) стоит если они будут использоваться в разных спеках
# Если спека одна то лучше вынести в before(для юнит тестов) и background(для фича тестов)
# иначе упадет читаемость кода
module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end