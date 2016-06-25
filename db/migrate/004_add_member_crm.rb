class AddMemberCrm < ActiveRecord::Migration
  def self.up
    add_column :fraternity_members, :name_suffix, :string
    add_column :fraternity_members, :pledge_class, :string
    add_column :fraternity_members, :little_bros, :text
    add_column :fraternity_members, :job_title, :string
    add_column :fraternity_members, :employer, :string
    add_column :fraternity_members, :giving_history, :text
    add_column :fraternity_members, :alumni_involvement, :text
    add_column :fraternity_members, :email_interaction, :text
    add_column :fraternity_members, :notes, :text
  end
end