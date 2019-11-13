class UploadedFile < ApplicationRecord
  belongs_to :storages, optional: true
end
