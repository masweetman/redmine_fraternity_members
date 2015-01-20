namespace :redmine do
  namespace :fraternity_members do

    desc "initializes the member database and adds new members"
    task :initialize => :environment do
		User.where(fraternity_member_id: nil).each do |user|
			user.new_fraternity_member
			user.save
		end
	end

    desc "Updates the member database"
    task :update => :environment do
		User.where(fraternity_member_id: 1..1000000).each do |user|
			user.update_fraternity_member
		end
    end
  end
end