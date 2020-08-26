class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy
  belongs_to :user

  # добавим декларацию, чтобы связать подключаемый файл(имеющий абстракцию в виде скрытой модели) с данной моделью (has_one_attached :file) для одного, (has_many_attached :files) - множество
  has_many_attached :files

  # accepts_nested_attributes_for макрос который коворит, что наша модель Question может принимать атрибуты для модели Link
  # и при создании вопроса создавать связанные с этим вопросом экземпляры(объекты) модели Link
  # чтобы избежать обязательной валидации полей ссылки используем reject_if и передадим метод который отбросит объект для валидации если его поле пусто, можно передать блок вместо all_blank и свою реализацию
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
end
