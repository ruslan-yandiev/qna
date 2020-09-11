FactoryBot.define do
  factory :reward do
    question
    user
    title
    image { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))] }
  end
end
