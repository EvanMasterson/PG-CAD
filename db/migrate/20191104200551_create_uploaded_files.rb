class CreateUploadedFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :uploaded_files do |t|
      t.string :name
      t.integer :size
      t.string :description
      t.string :unique_url

      t.timestamps
    end
  end
end
