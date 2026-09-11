class CreateInterviews < ActiveRecord::Migration[8.1]
  def change
    create_table :interviews do |t|
      t.references :application, null: false, foreign_key: true, index: { unique: true }
      t.datetime :scheduled_at, null: false
      t.integer  :duration_minutes, null: false, default: 30
      t.integer  :mode,   null: false, default: 0   # online/onsite/phone
      t.string   :meeting_link
      t.string   :location
      t.integer  :status, null: false, default: 0   # scheduled/completed/cancelled
      t.text     :notes

      t.timestamps
    end

    add_index :interviews, :scheduled_at
  end
end
