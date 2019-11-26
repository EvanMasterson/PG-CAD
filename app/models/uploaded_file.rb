class UploadedFile < ApplicationRecord
  belongs_to :storages, optional: true
  validates :name, presence: true
  mount_uploader :image, ImageUploader
  require 'securerandom'

  def set_self
    self[:unique_url] = SecureRandom.uuid
    self[:size] = image.size
  end
end
