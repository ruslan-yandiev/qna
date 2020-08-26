require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'set_best_value' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer_2) { create(:answer, :best, question: question, user: user) }

    before { answer.set_best_value }

    it 'choose the best answer' do
      expect(answer).to be_best
    end

    it 'should desable best for old answer' do
      expect(answer).to be_best
      answer_2.reload

      expect(answer_2).to_not be_best
    end
  end
end
