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
			user.pref.no_self_notified = true
			auto_register = false
		    if user.custom_field_value(54).downcase == Setting.plugin_redmine_fraternity_members[:fraternity_password].downcase
				member = FraternityMember.where(chapter: user.custom_field_value(2), active_number: user.custom_field_value(3)).first
				if member.nil?
			      	auto_register = true
				end
				if !member.nil?
					if (member.lastname.downcase == user.lastname.downcase || member.firstname.downcase == "unknown")
				      	auto_register = true
					end
				end
		    end

		    if auto_register
		    	register_automatically(user)
		    else
		    	register_manually_by_administrator_without_auto(user)
		    end

		end
	end
end

AccountController.send(:include, RegistrationPatch)
