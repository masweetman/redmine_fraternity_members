require 'user'

module UserPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			belongs_to :deliverable
		end
	end

	module InstanceMethods
		def new_fraternity_member
			return 'new_fraternity_member'
		end

		def update_fraternity_member
			return 'update_fraternity_member'
		end
	end
end

User.send(:include, UserPatch)