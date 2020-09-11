FactoryBot.define do
  sequence :title do |n|
    "Question_Title#{n}"
  end

  factory :question do
    user
    title
    body { "MyText" }
  end

  trait :with_file do
    # files { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'))] }
    files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))] }
  end

  # для реализации не стандартного
  trait :invalid do
    title { nil }
  end

  trait :with_reward do
    reward { create(:reward) }
  end
end
