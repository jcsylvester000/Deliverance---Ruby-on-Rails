class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.references :applicant,    null: false, foreign_key: { to_table: :users }
      t.references :job_posting,  null: false, foreign_key: true
      t.integer :stage, null: false, default: 0   # applied/under_review/interview/offer/onboarding/hired/rejected/withdrawn
      t.text    :cover_note

      t.timestamps
    end

    add_index :applications, [:applicant_id, :job_posting_id]
    add_index :applications, :stage
  end
end
