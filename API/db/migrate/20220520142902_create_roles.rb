class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :Name, null: false
      t.text :Description, null: false

      t.timestamps
    end
  end
end
