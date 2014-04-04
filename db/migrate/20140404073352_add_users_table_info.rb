class AddUsersTableInfo < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uniqid
      t.string :username
      t.string :password
      t.string :email
      t.string :salt
      t.string :name

      t.timestamps
    end

    create_table :auth_tokens do |t|
      t.integer :user_id
      t.string :providor
      t.string :secret
      t.string :token
      t.string :uuid

      t.timestamps
    end

  end
end
