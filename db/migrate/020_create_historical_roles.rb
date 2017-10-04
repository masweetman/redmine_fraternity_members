class CreateHistoricalRoles < ActiveRecord::Migration
  def change
    create_table :historical_roles do |t|
      t.integer :member_role_id
      t.integer :member_id
      t.integer :project_id
      t.integer :role_id
      t.integer :user_id
      t.date :added_on
      t.date :removed_on
    end
  end
end
