module RegistrationPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			#belongs_to :deliverable

			alias_method_chain :register_manually_by_administrator, :auto
		end
	end

	module InstanceMethods
		def register_manually_by_administrator_with_auto(user)
			auto_register = false
		    if user.custom_field_value(54).downcase == Setting.plugin_redmine_fraternity_members[:fraternity_password].downcase
				member = FraternityMember.where(chapter: user.custom_field_value(2), active_number: user.custom_field_value(3)).first
				if member.nil?
			      	auto_register = true
				end
				if !member.nil?
					if (member.lastname.downcase == user.lastname.downcase || member.firstname.downcase == 'unknown')
				      	auto_register = true
					end
				end
			elsif (user.custom_field_value(101).to_s == 'pledge' && user.custom_field_value(3).to_s == '0')
				auto_register = true
		    end

		    if auto_register
		    	register_automatically(user)

				if (user.custom_field_value(56).to_i >= Date.current.year && !Project.find_by_name(user.custom_field_value(2)).nil?)
					if user.custom_field_value(101).to_s == 'Active'
					  m = Member.new(:user => user, :roles => [Role.find_by_name('Active')])
					  Project.find_by_name(user.custom_field_value(2)).members << m
					elsif user.custom_field_value(101).to_s == 'pledge'
					  m = Member.new(:user => user, :roles => [Role.find_by_name('pledge')])
					  Project.find_by_name(user.custom_field_value(2)).members << m
					end
				end

				user.new_fraternity_member
				user.update_fraternity_member
				user.subscribe
		    else
		    	register_manually_by_administrator_without_auto(user)
		    end

		end
	end
end

AccountController.send(:include, RegistrationPatch)
