namespace :redmine do
  namespace :fraternity_members do
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

		User.all.each do |user|
			unless (user == User.anonymous || user.custom_field_value(3) == "0")
				if !user.fraternity_member_id?
					user.fraternity_member_id = FraternityMember.create.id
					user.save
				end
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
				member.address = user.custom_field_value(51).to_s + ", " + user.custom_field_value(52).to_s + ", " + user.custom_field_value(53).to_s + " " + user.custom_field_value(4).to_s
				member.graduation_year = user.custom_field_value(56)
				member.bio = user.custom_field_value(9)
				member.facebook = user.custom_field_value(57)
				member.linkedin = user.custom_field_value(58)
				member.redmine_user_id = user.id
				member.active = false
				Project.all.each do |project|
					if project.parent_id == 6
						if user.member_of?(project)
							member.active = true
						end
					end
				end
				member.save
			end
		end

    end
  end
end
