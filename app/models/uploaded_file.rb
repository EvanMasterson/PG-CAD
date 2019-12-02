class UploadedFile < ApplicationRecord
  belongs_to :storages, optional: true
  validates :name, presence: true
  mount_uploader :image, ImageUploader
  require 'securerandom'

  def set_self
    self[:unique_url] = SecureRandom.uuid
    self[:size] = image.size
    self[:name] = image.filename
  end

  def generate_shared_id
    self[:share_id] = SecureRandom.uuid
  end

end
