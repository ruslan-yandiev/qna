module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def vote_up(user)
    return if votes.find_by(value: -1, user: user)&.delete
    # find_or_create_by в отличии от create сначала поищит объект в базе с параметрами, если нашел вернет его, если нет то создаст. удобно.
    votes.find_or_create_by!(value: 1, user: user)
  end

  def vote_down(user)
    return if votes.find_by(value: 1, user: user)&.delete
    votes.find_or_create_by!(value: -1, user: user)
  end

  def all_likes
    votes.sum(:value)
  end
end