# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
# Удобно require(зарикваерим-импортируем) наши файлы с хелперами из директории spec/support
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # подключим из библиотеки FactoryBot набор методов
  config.include FactoryBot::Syntax::Methods

  # подключим специальный модуль для использования в тестах gem Devise
  config.include Devise::Test::ControllerHelpers, type: :controller
  
  # подключим наш модуль ControllerHelpers и только для тестов контроллеров
  config.include ControllerHelpers, type: :controller

  # подключим наш модуль FeatureHelpers и только для фича тестов
  config.include FeatureHelpers, type: :feature

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Укажем драйвер selenium_chrome (selenium_chrome_headless) - запуск в фоне, позволит нам запускать для тестов с использованием JS запускать браузер ХРОМ вместо Файр Фокса
  Capybara.javascript_driver = :selenium_chrome_headless

  # Увеличим ожидание ответа Ajax до 5 секунд
  Capybara.default_max_wait_time = 5

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # реализуем удаление ненужных файлов из тестов, чтобы не копить мусор добавленных файлов (удалим после прохождения папку storage)
  config.after(:all) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# подключим во все фабрики метод fixture_file_upload - это шорткат для Rack::Test::UploadedFile.new
FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end
