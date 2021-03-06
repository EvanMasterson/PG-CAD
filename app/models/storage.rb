class Storage < ApplicationRecord
  belongs_to :users,  optional: true
  has_many :uploaded_files, dependent: :destroy
  validates :name, presence: true

  def set_size
    self[:size] = calculate_storage_size
  end

  # iterating through on the uploaded files  in a storage and adding up their sizes to calculate storage size
  # returns a decimal number 
  def calculate_storage_size
    storage_size = 0;
    if self.uploaded_files
      self.uploaded_files.each do |file|
        storage_size += file.size
      end
    end
    return storage_size
  end
end
