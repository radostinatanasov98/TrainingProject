class CreateExaminations < ActiveRecord::Migration[7.0]
  def change
    create_table :examinations do |t|
      t.belongs_to :user, foreign_key: true
      t.float :weightKg, null: false
      t.float :heightCm, null: false
      t.text :anamnesis, null: false

      t.timestamps
    end
  end
end
