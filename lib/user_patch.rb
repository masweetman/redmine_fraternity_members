require 'user'
require 'mailchimp'

module UserPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			belongs_to :deliverable

			alias_method_chain :name, :pledge_name
			alias_method_chain :update, :update_fraternity_member
		end
	end

	module InstanceMethods

		def name_with_pledge_name(formatter = nil)
	   		f = self.class.name_formatter(formatter)
	   		if self.custom_field_value(1) == ""
	   			@name ||= eval('"' + f[:string] + '"')
	   		else
				@name ||= eval('"' + f[:string] + '"') + " (" + self.custom_field_value(1).truncate(12) + ")"
			end
		end

		def update_with_update_fraternity_member
			self.new_fraternity_member
			self.update_fraternity_member
			self.subscribe
			update_without_update_fraternity_member
		end

		def new_fraternity_member
			if (fraternity_member_id == nil && custom_field_value(3).to_i > 0)
				unless (anonymous? || !active?)
					member = FraternityMember.where(chapter: self.custom_field_value(2), active_number: self.custom_field_value(3)).first
					if member.nil?
						self.fraternity_member_id = FraternityMember.create.id
						self.save
					end
					if !member.nil?
						if (member.lastname.downcase == lastname.downcase || member.firstname.downcase == "unknown")
							self.fraternity_member_id = member.id
							self.save
						end
					end
				end
			end
		end

		def update_fraternity_member
			if (fraternity_member_id != nil && custom_field_value(3).to_i > 0)
				member = FraternityMember.find(fraternity_member_id)
				member.firstname = firstname
				member.middlename = custom_field_value(80)
				member.lastname = lastname
				member.mail = mail
				member.chapter = custom_field_value(2)
				member.active_number = custom_field_value(3).to_i
				member.pledge_name = custom_field_value(1)
				member.big_bro = custom_field_value(55)
				member.phone = custom_field_value(18)
				member.address = custom_field_value(4)
				member.graduation_year = custom_field_value(56).to_i
				member.bio = custom_field_value(9)
				member.facebook = custom_field_value(57)
				member.linkedin = custom_field_value(58)
				member.redmine_user_id = id
				member.active = projects.where(parent_id: 6).any?
				member.save
			end
		end

		def subscribe
			if !Setting.plugin_redmine_fraternity_members[:mailchimp_api_key].empty?
			    @mc = Mailchimp::API.new(Setting.plugin_redmine_fraternity_members[:mailchimp_api_key])
			    list_id = Setting.plugin_redmine_fraternity_members[:mailchimp_list_id]
			    @mc.lists.subscribe(list_id, {:email => mail},
			    	{'FNAME' => firstname,
			    	'LNAME' => lastname,
			    	'CHAPTER' => custom_field_value(2),
			    	'ACTIVE' => projects.where(parent_id: 6).any?},
			    	'html',
			    	false,
			    	true,
			    	true,
			    	false)
			end
		end

	end
end

User.send(:include, UserPatch)
