class CreateFraternityMembers < ActiveRecord::Migration
  def change
    create_table :fraternity_members do |t|
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :mail
      t.string :chapter
      t.integer :active_number
      t.string :pledge_name
      t.string :big_bro
      t.string :phone
      t.string :address
      t.integer :graduation_year
      t.text :bio
      t.string :facebook
      t.string :linkedin
      t.integer :redmine_user_id
    end
  end
end
