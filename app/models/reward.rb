class Reward < ApplicationRecord
  # optional: true отключает проверку присутствия для ассоциации, по дефолту установленно с пятых рельсов optional: false
  belongs_to :user, optional: true
  belongs_to :question
  
  has_one_attached :image

  validates :title, :image, presence: true
end
