class AddMToken < ActiveRecord::Migration
  
def self.up
  add_column :users, :m_token, :string
  add_column :users, :m_token_expires_at, :time
end

def self.down
  remove_column :users, :m_token
  remove_column :users, :m_token_expires_at
end
end

