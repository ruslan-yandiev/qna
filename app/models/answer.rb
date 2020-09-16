class Answer < ApplicationRecord
  include Votable
  include Linkable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  def set_best_value
    return if self.best
    question.answers.where(best: true).update(best: false)

    transaction do 
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
