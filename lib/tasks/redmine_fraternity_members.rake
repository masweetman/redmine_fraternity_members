namespace :redmine do
  namespace :fraternity_members do

    desc "initializes the member database and adds new members"
    task :initialize => :environment do
		User.where(fraternity_member_id: nil).each do |user|
			user.new_fraternity_member
		end
	end

    desc "Updates the member database"
    task :update => :environment do
		User.where('fraternity_member_id > ?', 0).each do |user|
			user.update_fraternity_member
		end
    end

    desc "Syncs the fraternity_members table with Mailchimp"
    task :mailchimp_sync_members => :environment do
		if !Setting.plugin_redmine_fraternity_members[:mailchimp_api_key].empty?
		    @mc = Mailchimp::API.new(Setting.plugin_redmine_fraternity_members[:mailchimp_api_key])
		    list_id = Setting.plugin_redmine_fraternity_members[:mailchimp_list_id]
			FraternityMember.where('mail != ?', '').each do |member|
			    @mc.lists.subscribe(list_id, {:email => member.mail},
			    	{'FNAME' => member.firstname,
			    	'LNAME' => member.lastname,
			    	'CHAPTER' => member.chapter,
			    	'ACTIVE' => member.active,
			    	'html',
			    	false,
			    	true,
			    	true,
			    	false)
			end
		end
    end

    desc "Syncs the users table with Mailchimp"
    task :mailchimp_sync_users => :environment do
    	if !Setting.plugin_redmine_fraternity_members[:mailchimp_api_key].empty?
			User.where('fraternity_member_id > ?', 0).each do |user|
				user.subscribe
			end
		end
    end

  end
end