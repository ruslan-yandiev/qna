class Question < ApplicationRecord
  include Votable
  include Linkable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user

  # добавим декларацию, чтобы связать подключаемый файл(имеющий абстракцию в виде скрытой модели) с данной моделью (has_one_attached :file) для одного, (has_many_attached :files) - множество
  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
end
