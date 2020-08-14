FactoryBot.define do
  factory :answer do
    user
    question
    body { 'MyText' }

    trait :invalid do
      body { nil }
    end
  end
end