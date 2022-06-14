class RenameWeightKgAndHeightCmInExaminationsTable < ActiveRecord::Migration[7.0]
  def change
    change_table :examinations do |t|
      t.rename :weightKg, :weight_kg
      t.rename :heightCm, :height_cm
    end
  end
end
