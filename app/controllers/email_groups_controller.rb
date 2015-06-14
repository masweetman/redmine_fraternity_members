class EmailGroupsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index

		#national council members
		@national_council = Project.find(6).users
		for user in @national_council
			if (user.roles_for_project(Project.find(6)).first.id == 36 ||
				user.roles_for_project(Project.find(6)).first.id == 39) &&
				user.roles_for_project(Project.find(6)).length == 1
				@national_council -= [user]
			end
		end

		@advisors = []
		@presidents = []
		@vice_presidents = []
		@chaplains = []
		@pledgemasters = []
		@treasurers = []
		@house_managers = []
		@secretaries =[]
		@social_media_managers = []
		@actives = []
		@agodelphian_editors = []

		for chapter in Project.where(:parent_id => 6)
			for user in chapter.users
				case
				when user.roles_for_project(chapter).include?(Role.find_by_name("Chapter Advisor"))
					@advisors << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("President"))
					@presidents << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Vice President"))
					@vice_presidents << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Chaplain"))
					@chaplains << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Pledgemaster"))
					@pledgemasters << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Treasurer"))
					@treasurers << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("House Manager"))
					@house_managers << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Secretary"))
					@secretaries << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Social Media Manager"))
					@social_media_managers << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("Active"))
					@actives << user
				when user.roles_for_project(chapter).include?(Role.find_by_name("AGODelphian Editor"))
					@agodelphian_editors << user
				end
			end
		end

		@advisors += @national_council
		@agodelphian_editors += @advisors
		@presidents += @advisors
		@vice_presidents += @presidents
		@chaplains += @presidents
		@pledgemasters += @presidents
		@treasurers += @presidents
		@house_managers += @presidents
		@secretaries += @presidents
		@social_media_managers += @presidents
		@officers = @vice_presidents + @chaplains + @pledgemasters + @treasurers + @house_managers + @secretaries
		@actives += @officers + @social_media_managers + @agodelphian_editors
		
		@national_council = @national_council.uniq
		@advisors = @advisors.uniq
		@agodelphian_editors = @agodelphian_editors.uniq
		@presidents = @presidents.uniq
		@vice_presidents = @vice_presidents.uniq
		@chaplains = @chaplains.uniq
		@pledgemasters = @pledgemasters.uniq
		@treasurers = @treasurers.uniq
		@house_managers = @house_managers.uniq
		@secretaries = @secretaries.uniq
		@social_media_managers = @social_media_managers.uniq
		@officers = @officers.uniq
		@actives = @actives.uniq

		@chapters = {}
		for chapter in Project.where(:parent_id => 6).sort
			@chapters[chapter.name] = []
			@chapters[chapter.name][0] = []
			@chapters[chapter.name][1] = []
			@chapters[chapter.name][2] = []
			for user in @advisors
				if user.member_of?(chapter)
					@chapters[chapter.name][0] << user
				end
			end
			for user in @officers
				if user.member_of?(chapter)
					@chapters[chapter.name][1] << user
				end
			end
			for user in @actives
				if user.member_of?(chapter)
					@chapters[chapter.name][2] << user
				end
			end
		end
		


	end
end