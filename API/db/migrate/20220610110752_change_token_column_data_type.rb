class ChangeTokenColumnDataType < ActiveRecord::Migration[7.0]
  def up
    change_column :oauth_access_tokens, :token, :string, limit: 700
  end

  def down
    change_column :oauth_access_tokens, :token, :string
  end
end
