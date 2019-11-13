class Storage < ApplicationRecord
  belongs_to :users,  optional: true
  has_many :uploaded_files
end
