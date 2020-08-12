require 'rails_helper'

RSpec.describe User, type: :model do
  # по сути раз мы используем gem 'devise' то и эти юнит тесты можно не писать
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
