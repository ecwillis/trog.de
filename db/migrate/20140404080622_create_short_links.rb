class CreateShortLinks < ActiveRecord::Migration
  def change
    create_table :short_links do |t|
      t.string :link
      t.string :short_id
      t.string :link_hash
      t.integer :clicks
      
      t.integer :user_id
      t.string :session_id

      t.timestamps
    end
  end
end
