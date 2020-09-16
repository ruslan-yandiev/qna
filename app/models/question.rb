class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable # укажем, что эта связь полиморфная добавив хэш as: :linkable
  has_one :reward, dependent: :destroy
  belongs_to :user

  # добавим декларацию, чтобы связать подключаемый файл(имеющий абстракцию в виде скрытой модели) с данной моделью (has_one_attached :file) для одного, (has_many_attached :files) - множество
  has_many_attached :files

  # accepts_nested_attributes_for макрос который коворит, что наша модель Question может принимать атрибуты для модели Link
  # и при создании вопроса создавать связанные с этим вопросом экземпляры(объекты) модели Link
  # чтобы избежать обязательной валидации полей ссылки используем reject_if и передадим метод который отбросит объект для валидации если его поле пусто, можно передать блок вместо all_blank и свою реализацию
  # добавим , allow_destroy: true для возможности удаления
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
end
