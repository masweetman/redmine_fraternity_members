module RedmineFraternityMembersPlugin
	class Hooks < Redmine::Hook::ViewListener

		def controller_account_before_registration(context={})
			Setting.self_registration = '2'
			user = context[:user]
		    if user.custom_field_value(54).downcase == Setting.plugin_redmine_fraternity_members[:fraternity_password].downcase
				member = FraternityMember.where(chapter: user.custom_field_value(2), active_number: user.custom_field_value(3)).first
				if member.nil?
			      	Setting.self_registration = '3'
				end
				if !member.nil?
					if (member.lastname.downcase == user.lastname.downcase || member.firstname.downcase == "unknown")
				      	Setting.self_registration = '3'
					end
				end
		    end
		end

		def controller_account_after_registration(context={})
			Setting.self_registration = '2'
			user = context[:user]
			if (user.projects.count == 0 && user.custom_field_value(56).to_i >= Date.current.year)
			  m = Member.new(:user => user, :roles => [Role.find_by_name('Active')])
			  if !Project.find_by_name(user.custom_field_value(2)).nil?
			  	Project.find_by_name(user.custom_field_value(2)).members << m
			  end
			end

			user.new_fraternity_member
			user.update_fraternity_member
		end
		
	end
end
