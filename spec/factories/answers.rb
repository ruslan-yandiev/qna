FactoryBot.define do
  factory :answer do
    user
    question
    body { 'My_Answer_Text' }

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end