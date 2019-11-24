class AddImageToUploadedFile < ActiveRecord::Migration[5.0]
  def change
    add_column :uploaded_files, :image, :string
  end
end
