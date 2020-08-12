FactoryBot.define do
  # создает последовательность некоторых значений
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    # название атрибута и самой последовательности совпадает, по этому просто укажем email
    email
    password { '12345678' }

    # потребуется для создания валидного объекта
    password_confirmation { '12345678' }
  end
end
