FactoryBot.define do
  sequence :title do |n|
    "Question_Title#{n}"
  end

  factory :question do
    user
    title
    body { "MyText" }
  end

  # для реализации не стандартного
  trait :invalid do
    title { nil }
  end
end
