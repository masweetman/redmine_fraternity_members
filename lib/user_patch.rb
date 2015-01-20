require 'user'

module UserPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			belongs_to :deliverable

			alias_method_chain :save, :update_fraternity_member
		end
	end

	module InstanceMethods
		def new_fraternity_member
			if (fraternity_member_id == nil && custom_field_value(3).to_i > 0)
				unless (anonymous? || !active?)
					member = FraternityMember.where(chapter: custom_field_value(2), active_number: custom_field_value(3)).first
					if member.nil?
						self.fraternity_member_id = FraternityMember.create.id
						#self.save
					end
					if !member.nil?
						if ((lastname.downcase == member.lastname.downcase) or (member.lastname.downcase == "unknown") or (member.lastname.downcase == ""))
							self.fraternity_member_id = member.id
							#self.save
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

		def save_with_update_fraternity_member
			save_without_update_fraternity_member
			if !active?
		      if custom_field_value(54).downcase == Setting.plugin_redmine_fraternity_members[:fraternity_password].downcase
		      	self.activate
		      	Mailer.account_activated(self).deliver
		      end
			end

			if (projects.count == 0 && custom_field_value(56).to_i >= Date.current.year)
			  m = Member.new(:user => self, :roles => [Role.find_by_name('Active')])
			  if !Project.find_by_name(custom_field_value(2)).nil?
			  	Project.find_by_name(custom_field_value(2)).members << m
			  end
			end

			self.new_fraternity_member
			save_without_update_fraternity_member
			self.update_fraternity_member
			#custom_field_value :id => 54, :value => "-"
			
		end

	end
end

User.send(:include, UserPatch)