class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Deliverance — the get-to-know-you answers
      t.integer :role,              null: false, default: 0   # 0 job_poster, 1 applicant  (Q1)
      t.integer :organization_type, null: false, default: 1   # 0 agency, 1 individual, 2 company_representative (Q2)
      t.string  :heard_from                                    # optional (Q3)

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :role
  end
end
