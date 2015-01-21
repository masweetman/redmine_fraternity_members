require 'news'

module NewsPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			belongs_to :deliverable

			alias_method_chain :recipients, :actives
		end
	end

	module InstanceMethods

		def recipients_with_actives
			recipients_without_actives
			#removes Accountants from email list
			project.users.select {|user| user.notify_about?(self) && user.allowed_to?(:view_news, project) && user.roles_for_project(project) != [Role.find(36)]}.map(&:mail)
			
			#adds all actives as recipients of news on National Council project
			if project.id == 6
				actives = []
				Project.where(parent_id: 6).each do |chapter|
					chapter.members.each do |member|
						if !actives.include?(member.user) && member.user.roles_for_project(Project.find(6)) != [Role.find(36)]
							actives << member.user
						end
					end
				end
				actives = actives.map(&:mail)
				actives
			end
		end

	end
end