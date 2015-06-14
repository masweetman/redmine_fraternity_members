module EmailGroupsHelper

	def email_address_string(users)
		mailto = ""
		for u in users
			mailto += u.mail + ","
		end
		return mailto
	end

end
