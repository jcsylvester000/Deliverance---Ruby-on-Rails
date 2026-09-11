class CreateApplicantProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :applicant_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string  :headline
      t.boolean :discoverable, null: false, default: false   # Phase 6 opt-in; column added now

      t.timestamps
    end
  end
end
