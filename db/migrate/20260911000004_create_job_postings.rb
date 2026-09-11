class CreateJobPostings < ActiveRecord::Migration[8.1]
  def change
    create_table :job_postings do |t|
      t.references :poster, null: false, foreign_key: { to_table: :users }
      t.string  :title,       null: false
      t.text    :description,  null: false
      t.string  :location
      t.integer :employment_type,  null: false, default: 0   # temporary/project_based/full_time_benefits/gig
      t.integer :work_arrangement, null: false, default: 0   # remote/hybrid/onsite
      t.integer :status,           null: false, default: 0   # draft/published/closed
      t.integer :compensation_cents                          # money as integer smallest unit
      t.integer :compensation_period                         # hourly/monthly/fixed (nullable)

      t.timestamps
    end

    add_index :job_postings, :status
    add_index :job_postings, [:status, :created_at]
  end
end
