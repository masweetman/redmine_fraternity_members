module NewsControllerPatch
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
	    # deny access to non-members
	  	unless User.current.fraternity_member_id.to_i > 0
	  		deny_access
	  		return
	  	end
	  end
	  
	end

end

NewsController.send(:include, NewsControllerPatch)
