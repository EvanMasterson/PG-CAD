class AddSelectedPackageToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :selected_package, :string
  end
end
