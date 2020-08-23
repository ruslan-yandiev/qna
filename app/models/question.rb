class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  # добавим декларацию, чтобы связать подключаемый файл(имеющий абстракцию в виде скрытой модели) с данной моделью (has_one_attached :file) для одного, (has_many_attached :files) - множество
  has_many_attached :files

  validates :title, :body, presence: true
end
