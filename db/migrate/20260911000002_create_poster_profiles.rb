class CreatePosterProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :poster_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :company_name
      t.text   :about

      t.timestamps
    end
  end
end
