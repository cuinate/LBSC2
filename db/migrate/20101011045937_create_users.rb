class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :e_mail
      t.string :scores
      t.string :profile_img
      

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
