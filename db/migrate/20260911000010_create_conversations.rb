class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.integer :kind, null: false, default: 0   # direct/group
      t.string  :title

      t.timestamps
    end
  end
end
