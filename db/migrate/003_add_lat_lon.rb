class AddLatLon < ActiveRecord::Migration
  def self.up
    add_column :fraternity_members, :latitude, :float
    add_column :fraternity_members, :longitude, :float
  end
end