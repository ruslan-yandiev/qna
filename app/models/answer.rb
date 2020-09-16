class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def vote_up(user)
    return if votes.find_by(value: -1, user: user)&.delete
    votes.find_or_create_by!(value: 1, user: user)
  end

  def vote_down(user)
    return if votes.find_by(value: 1, user: user)&.delete
    votes.find_or_create_by!(value: -1, user: user)
  end

  def all_likes
    votes.sum(:value)
  end

  def set_best_value
    return if self.best
    question.answers.where(best: true).update(best: false)

    transaction do 
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
