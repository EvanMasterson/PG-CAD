class AddUserReferenceToStorage < ActiveRecord::Migration[5.0]
  def change
    add_reference :storages, :user, foreign_key: true
  end
end
