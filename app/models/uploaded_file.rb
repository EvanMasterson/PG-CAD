class UploadedFile < ApplicationRecord
  has_and_belongs_to_many :storages
end
