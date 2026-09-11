class CreateOnboardingDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :onboarding_documents do |t|
      t.references :application, null: false, foreign_key: true
      t.integer :kind,   null: false, default: 0   # id_photo/resume/other
      t.integer :status, null: false, default: 0   # requested/uploaded

      t.timestamps
    end

    add_index :onboarding_documents, [:application_id, :kind], unique: true
  end
end
