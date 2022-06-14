class CreatePerscription < ActiveRecord::Migration[7.0]
  def change
    create_table :perscriptions do |t|
      t.belongs_to :examination, foreign_key: true
      t.text :description
      t.timestamps
    end
  end
end
