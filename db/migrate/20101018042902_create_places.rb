class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.string :address
      t.decimal :latitude, :precision => 9, :scale => 6
      t.decimal :longtitude, :precision => 9, :scale => 6
      t.integer :postalcode
      t.string  :city
      t.string  :pic_url
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
