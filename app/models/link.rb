class Link < ApplicationRecord
  # полиморфные ассоциации позволяют нам указать лишь одну belongs_to и это позволит привязывать объекты этой модели к разным другим моделям
  # без надомности прописывать множество belongs_to и сложных валидаций. принято полиморфную ассоциацию заканчивать на able
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI.regexp(['http', 'https', 'ftp'])
end
