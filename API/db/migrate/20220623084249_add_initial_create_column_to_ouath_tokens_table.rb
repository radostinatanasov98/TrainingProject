class AddInitialCreateColumnToOuathTokensTable < ActiveRecord::Migration[7.0]
  def change
    add_column :oauth_access_tokens, :initial_create, :datetime, null: false
  end
end
