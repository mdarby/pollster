class CreatePolls < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
      t.string :name
      t.text :description
      t.text :options
      t.date :ends_at
      t.text :string
      
      t.timestamps
    end
  end

  def self.down
    drop_table :polls
  end
end