class DropBookmarks < ActiveRecord::Migration[7.0]
  def change
    drop_table :bookmarks do |t|
      t.string :title
      t.string :url

      t.timestamps null: false
    end
  end
end
