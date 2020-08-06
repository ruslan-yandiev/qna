FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
  end

  # для реализации не стандартного
  trait :invalid do
    title { nil }
  end
end
