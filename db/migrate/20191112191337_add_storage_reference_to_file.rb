class AddStorageReferenceToFile < ActiveRecord::Migration[5.0]
  def change
    add_reference :uploaded_files, :storage, foreign_key: true
  end
end
