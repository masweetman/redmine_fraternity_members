module EmailGroupsHelper

	def email_address_string(users)
		mailto = ""
		for u in users
			mailto += u.mail + ";"
		end
		return mailto
	end


	#delete everyting below this line when finished

	def advisors(chapter)
		users = national_council
		role = Role.find_by_name("Chapter Advisor")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		users = users.uniq
	end

	def officers(chapter)
		users = advisors(chapter)
		role = Role.find_by_name("Chapter Advisor")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("President")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("Vice President")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("Chaplain")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("Pledgemaster")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("Treasurer")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("House Manager")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		role = Role.find_by_name("Secratary")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		users = users.uniq
	end

	def actives(chapter)
		users = officers(chapter)
		role = Role.find_by_name("Active")
		for user in chapter.users
			if user.roles_for_project(chapter).include?(role)
				users << user
			end
		end
		users = users.uniq
	end



end
