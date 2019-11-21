class UploadedFile < ApplicationRecord
  belongs_to :storages, optional: true
  validates :name, presence: true
end
