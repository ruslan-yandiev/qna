class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_best_value
    return if self.best == true

    transaction do
      question.answers.where(best: true).update(best: false)
      update(best: true)
    end
  end
end
