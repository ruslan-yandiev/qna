require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_values('http://google.com', 'https://google.com', 'ftp://google.com').for(:url) }
  it { should_not allow_values('google.com', 'yandex.ru').for(:url) }
end
