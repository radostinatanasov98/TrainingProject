class MakeInitialCreateNullable < ActiveRecord::Migration[7.0]
  def up
    change_column :oauth_access_tokens, :initial_create, :datetime, null: true
  end

  def down
    change_column :oauth_access_tokens, :initial_create, :datetime, null: false
  end
end
