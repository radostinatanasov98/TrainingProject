class AddFirstNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :roles, null: false, foreign_key: true, :default => 1
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :address, :string, null: false
    add_column :users, :date_of_birth, :date, null: false
  end
end