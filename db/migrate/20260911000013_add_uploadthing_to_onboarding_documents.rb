class AddUploadthingToOnboardingDocuments < ActiveRecord::Migration[8.1]
  def change
    add_column :onboarding_documents, :file_url,  :string
    add_column :onboarding_documents, :file_key,  :string
    add_column :onboarding_documents, :file_name, :string
    add_column :onboarding_documents, :byte_size, :bigint
  end
end
