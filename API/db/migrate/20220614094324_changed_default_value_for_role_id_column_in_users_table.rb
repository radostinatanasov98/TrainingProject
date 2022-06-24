class ChangedDefaultValueForRoleIdColumnInUsersTable < ActiveRecord::Migration[7.0]
  def change
    change_column_default(
      :users,
      :role_id,
      from: 1,
      to: 2
    )
  end
end
