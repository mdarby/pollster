class CreatePollsterTables < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string :name
      t.text :description
      t.text :options
      t.date :ends_at
      t.text :string
      t.integer :created_by_id
      
      t.timestamps
    end
    
    create_table :<%= object_name %>_votes do |t|
      t.integer :user_id
      t.string :vote
      t.integer :<%= object_name %>_id

      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
    drop_table :<%= table_name %>_votes
  end
end