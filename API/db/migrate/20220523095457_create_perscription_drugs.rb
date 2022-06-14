class CreatePerscriptionDrugs < ActiveRecord::Migration[7.0]
  def change
    create_table :perscription_drugs, id: false do |t|
      t.belongs_to :perscription, foreign_key: true
      t.belongs_to :drug, foreign_key: true
      t.text :usage_description, null: false
    end
  end
end
