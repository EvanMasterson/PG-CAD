class CreateUploadedFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :uploaded_files do |t|
      t.string :name, null: false, default: ""
      t.integer :size, null: false, default: 0
      t.string :unique_url, null: false, default: ""

      t.timestamps
    end
  end
end
