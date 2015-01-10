namespace :redmine do
  namespace :fraternity_members do

    desc "initializes the member database and adds new members"
    task :initialize => :environment do
		User.where(fraternity_member_id: nil).each do |user|
			unless (user == User.anonymous || !user.active?)
				member = FraternityMember.where(chapter: user.custom_field_value(2), active_number: user.custom_field_value(3)).first
				if member.nil?
					user.fraternity_member_id = FraternityMember.create.id
					user.save
				end
				if !member.nil?
					if user.lastname == member.lastname
						user.fraternity_member_id = member.id
						user.save
					end
				end

			end
		end
	end

    desc "Updates the member database"
    task :update => :environment do

		# 80 - Middle Name
		# 1 - Pledge Name
		# 2 - Chapter
		# 3 - Active Number
		# 55 - Big Bro
		# 18 - Phone Number
		# 51 - Address
		# 52 - City
		# 53 - State
		# 4 - Zip Code
		# 56 - Graduation Year
		# 9 - Biographical
		# 57 - Facebook
		# 58 - LinkedIn

		User.where(fraternity_member_id: 1..1000000).each do |user|
			member = FraternityMember.find(user.fraternity_member_id)
			member.firstname = user.firstname
			member.middlename = user.custom_field_value(80)
			member.lastname = user.lastname
			member.mail = user.mail
			member.chapter = user.custom_field_value(2)
			member.active_number = user.custom_field_value(3)
			member.pledge_name = user.custom_field_value(1)
			member.big_bro = user.custom_field_value(55)
			member.phone = user.custom_field_value(18)
			member.address = user.custom_field_value(4)
			member.graduation_year = user.custom_field_value(56)
			member.bio = user.custom_field_value(9)
			member.facebook = user.custom_field_value(57)
			member.linkedin = user.custom_field_value(58)
			member.active = user.projects.where(parent_id: 6).any?
			member.save
		end
    end
  end
end