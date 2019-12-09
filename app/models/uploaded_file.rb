class UploadedFile < ApplicationRecord
  belongs_to :storages, optional: true
  validates :name, presence: true
  # mount cariervawes ImageUploader
  mount_uploader :image, ImageUploader
  require 'securerandom'

  def set_self
    # using SecureRandom to generate unique uuid for file path
    self[:unique_url] = SecureRandom.uuid
    self[:size] = image.size
    self[:name] = image.filename
  end

end
