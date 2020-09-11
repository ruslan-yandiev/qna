FactoryBot.define do
  factory :reward do
    question
    user
    title
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb')) }
  end
end
