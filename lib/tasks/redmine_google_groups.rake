namespace :redmine do
  namespace :google_groups do

    task :update_groups => :environment do
    	national = {}
    	national['Council'] = []
    	national['Exec'] = []
    	national['Pres'] = []
    	national['VPC'] = []
    	national['VPA'] = []
    	national['Chap'] = []
    	national['Treas'] = []
    	national['Sec'] = []
    	national['DC North'] = []
    	national['DC South'] = []
    	national['DC Central'] = []
    	national['DC Mountain'] = []
    	national['AGODelphian'] = []
    	national['Accountant'] = []

    	national['AGOm'] = Project.find('agom').users
    	national['AAI'] = Project.find('aai').users
    	national['ABA'] = Project.find('aba').users
    	national['LOH'] = Project.find('loh').users

    	for user in Project.find(6).users
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl President"))
    			national['Council'] << user
    			national['Exec'] << user
    			national['Pres'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl VP Collegiate"))
    			national['Council'] << user
    			national['Exec'] << user
    			national['VPC'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl VP Alumni"))
    			national['Council'] << user
    			national['Exec'] << user
    			national['VPA'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl Chaplain"))
    			national['Council'] << user
    			national['Exec'] << user
    			national['Chap'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl Treasurer"))
    			national['Council'] << user
    			national['Exec'] << user
    			national['Treas'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl Secretary"))
    			national['Council'] << user
    			national['Exec'] << user
    			national['Sec'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - North"))
    			national['Council'] << user
    			national['DC North'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - Central"))
    			national['Council'] << user
    			national['DC Central'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - South"))
    			national['Council'] << user
    			national['DC South'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - Mountain"))
    			national['Council'] << user
    			national['DC Mountain'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("First Herald - LOH"))
    			national['Council'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("AGODelphian Editor"))
    			national['AGODelphian'] << user
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Accountant"))
    			national['Accountant'] << user
    		end
    	end

    	national['Advisors'] = national['Council']
    	national['All Alumni Leaders'] = national['Council'] + national['AGODelphian'] + national['AGOm'] + national['AAI'] + national['ABA'] + national['LOH']
    	national['All Chapter Exec'] = []
    	national['All Pres'] = []
    	national['All VP'] = []
    	national['All Chap'] = []
    	national['All PM'] = []
    	national['All Treas'] = []
    	national['All HM'] = []
    	national['All Sec'] = []
    	national['All Social'] = []
    	national['All Actives'] = national['Council'] + national['AGODelphian']
		
		chapters = {}
		for c in Project.where(:parent_id => 6)
			chapters[c.identifier] = {}
			chapters[c.identifier]['Actives'] = []
			chapters[c.identifier]['Exec'] = []
			chapters[c.identifier]['Advisors'] = []
			chapters[c.identifier]['President'] = []
			chapters[c.identifier]['Vice President'] = []
			chapters[c.identifier]['Chaplain'] = []
			chapters[c.identifier]['Pledgemaster'] = []
			chapters[c.identifier]['Treasurer'] = []
			chapters[c.identifier]['House Manager'] = []
			chapters[c.identifier]['Secretary'] = []
			chapters[c.identifier]['Social Media Manager'] = []

			for user in c.users
				if user.roles_for_project(c).include?(Role.find_by_name("Chapter Advisor"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['Advisors'] << user
					chapters[c.identifier]['President'] << user
					chapters[c.identifier]['Vice President'] << user
					chapters[c.identifier]['Chaplain'] << user
					chapters[c.identifier]['Pledgemaster'] << user
					chapters[c.identifier]['Treasurer'] << user
					chapters[c.identifier]['House Manager'] << user
					chapters[c.identifier]['Secretary'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("President"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['President'] << user
					chapters[c.identifier]['Vice President'] << user
					chapters[c.identifier]['Chaplain'] << user
					chapters[c.identifier]['Pledgemaster'] << user
					chapters[c.identifier]['Treasurer'] << user
					chapters[c.identifier]['House Manager'] << user
					chapters[c.identifier]['Secretary'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Vice President"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['Vice President'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Chaplain"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['Chaplain'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Pledgemaster"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['Pledgemaster'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Treasurer"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['Treasurer'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("House Manager"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['House Manager'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Secretary"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Exec'] << user
					chapters[c.identifier]['Secretary'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Social Media Manager"))
					chapters[c.identifier]['Actives'] << user
					chapters[c.identifier]['Social Media Manager'] << user
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Active"))
					chapters[c.identifier]['Actives'] << user
				end
			end

			for group in chapters[c.identifier]
				group[1].uniq!
			end

	    	national['Advisors'] += chapters[c.identifier]['Advisors']
	    	national['All Alumni Leaders'] += chapters[c.identifier]['Advisors']
	    	national['All Chapter Exec'] += chapters[c.identifier]['Exec']
	    	national['All Pres'] += chapters[c.identifier]['President']
	    	national['All VP'] += chapters[c.identifier]['Vice President']
	    	national['All Chap'] += chapters[c.identifier]['Chaplain']
	    	national['All PM'] += chapters[c.identifier]['Pledgemaster']
	    	national['All Treas'] += chapters[c.identifier]['Treasurer']
	    	national['All HM'] += chapters[c.identifier]['House Manager']
	    	national['All Sec'] += chapters[c.identifier]['Secretary']
	    	national['All Social'] += chapters[c.identifier]['Social Media Manager']
	    	national['All Actives'] += chapters[c.identifier]['Actives']
	    	
		end

		national['Everyone'] = national['All Actives'] + national['All Alumni Leaders']
		for group in national
			group[1].uniq!
		end

		#add new google groups
		google_directory = GoogleDirectory.new
		google_directory.cache_directory_api_file
		google_directory.update_groups

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Council']
    	users = national['Council']
    	google_directory.update_members(group, users) unless group.empty?

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Exec']
    	users = national['Exec']
    	google_directory.update_members(group, users) unless group.empty?

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National President']
    	users = national['Pres']
    	google_directory.update_members(group, users) unless group.empty?

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['VP Collegiate Chapters']
    	users = national['VPC']
    	google_directory.update_members(group, users) unless group.empty?

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['VP Alumni']
    	users = national['VPA']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Chaplain']
    	users = national['Chap']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Treasurer']
    	users = national['Treas']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Secretary']
    	users = national['Sec']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC North']
    	users = national['DC North']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC South']
    	users = national['DC South']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC Central']
    	users = national['DC Central']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC Mountain']
    	users = national['DC Mountain']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['AGODelphian Editors']
    	users = national['AGODelphian']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['Accountant']
    	users = national['Accountant']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['AGOm']
    	users = national['AGOm']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['AAI']
    	users = national['AAI']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['Beta Housing Board']
    	users = national['ABA']
    	google_directory.update_members(group, users) unless group.empty?

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['Legion of Honor']
    	users = national['LOH']
    	google_directory.update_members(group, users) unless group.empty?

    	#update chapter email groups
    	for c in Project.where(:parent_id => 6)
            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Actives']
            users = chapters[c.identifier]['Actives']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Exec']
            users = chapters[c.identifier]['Exec']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Advisors']
            users = chapters[c.identifier]['Advisors']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' President']
            users = chapters[c.identifier]['President']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Vice President']
            users = chapters[c.identifier]['Vice President']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Chaplain']
            users = chapters[c.identifier]['Chaplain']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Pledgemaster']
            users = chapters[c.identifier]['Pledgemaster']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Treasurer']
            users = chapters[c.identifier]['Treasurer']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' House Manager']
            users = chapters[c.identifier]['House Manager']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Secretary']
            users = chapters[c.identifier]['Secretary']
            google_directory.update_members(group, users) unless group.empty?

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Social Media']
            users = chapters[c.identifier]['Social Media Manager']
            google_directory.update_members(group, users) unless group.empty?
    	end

    end

  end
end