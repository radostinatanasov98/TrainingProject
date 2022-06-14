class RenameDescriptionAndNameInRoles < ActiveRecord::Migration[7.0]
  def change
    change_table :roles do |t|
      t.rename :Description, :description
      t.rename :Name, :name
    end

    change_table :users do |t|
      t.rename :roles_id, :role_id
    end
  end
end
