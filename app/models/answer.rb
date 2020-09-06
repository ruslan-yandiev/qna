class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def set_best_value
    return if self.best
    question.answers.where(best: true).update(best: false)
    transaction { update!(best: true) }
  end
end
