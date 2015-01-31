module WikiControllerPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			#belongs_to :deliverable

			before_filter :find_role, :only => [:index, :show]
		end
	end

	module InstanceMethods

	  def find_role
	    Project.all.each do |project|
	      # deny access to pledges
	      if User.current.roles_for_project(project).include? Role.find(40)
	        deny_access
	        return
	      end
	    end
	  end
	end

end

WikiController.send(:include, WikiControllerPatch)
