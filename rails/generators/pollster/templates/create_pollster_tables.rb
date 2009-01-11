class CreatePollsterTables < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
      t.string :name
      t.text :description
      t.text :options
      t.date :ends_at
      t.text :string
      
      t.timestamps
    end
    
    create_table :poll_votes do |t|
      t.integer :user_id
      t.string :vote
      t.integer :poll_id

      t.timestamps
    end
  end

  def self.down
    drop_table :polls
    drop_table :poll_votes
  end
end