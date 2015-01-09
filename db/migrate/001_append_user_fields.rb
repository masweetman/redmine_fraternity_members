class AppendUserFields < ActiveRecord::Migration
  def self.up
    add_column :users, :fraternity_member_id, :integer
  end

  def self.down
    remove_column :users, :fraternity_member_id
  end

end