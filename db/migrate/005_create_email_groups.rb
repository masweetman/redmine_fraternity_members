class CreateEmailGroups < ActiveRecord::Migration
  def change
    create_table :email_groups do |t|
      t.string :organization
      t.string :name
      t.string :address
      t.string :description
    end
  end
end
