class CreateEmailGroupMemberships < ActiveRecord::Migration
  def change
    create_table :email_group_memberships do |t|
      t.integer :include_project_id
      t.boolean :include_project_children
      t.integer :include_role_id
      t.integer :include_email_group_id
      t.integer :exclude_project_id
      t.integer :exclude_role_id
      t.references :email_group, foreign_key: true
    end
  end
end
