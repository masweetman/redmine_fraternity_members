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
    	google_directory.update_members(group, users)

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Exec']
    	users = national['Exec']
    	google_directory.update_members(group, users)

    	#update chapter email groups
    	#for c in Project.where(:parent_id => 6)
    	#	group_actives = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Actives']
    	#	group_exec = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Exec']
    	#	group_advisors = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Advisors']
    	#	group_pres = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' President']
    	#	group_vp = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Vice President']
    	#	group_chap = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Chaplain']
    	#	group_pm = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Pledgemaster']
    	#	group_treas = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Treasurer']
    	#	group_hm = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' House Manager']
    	#	group_sec = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Secretary']
    	#	group_social = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'][c.name + ' Social Media']

		#	users_actives = chapters[c.identifier]['Actives']
		#	users_exec = chapters[c.identifier]['Exec']
		#	users_advisors = chapters[c.identifier]['Advisors']
		#	users_pres = chapters[c.identifier]['President']
		#	users_vp = chapters[c.identifier]['Vice President']
		#	users_chap = chapters[c.identifier]['Chaplain']
		#	users_pm = chapters[c.identifier]['Pledgemaster']
		#	users_treas = chapters[c.identifier]['Treasurer']
		#	users_hm = chapters[c.identifier]['House Manager']
		#	users_sec = chapters[c.identifier]['Secretary']
		#	users_social = chapters[c.identifier]['Social Media Manager']
			
		#	google_directory.update_members(group_actives, users_actives) unless group_actives.empty?
		#	google_directory.update_members(group_exec, users_exec) unless group_exec.empty?
		#	google_directory.update_members(group_advisors, users_advisors) unless group_advisors.empty?
		#	google_directory.update_members(group_pres, users_pres) unless group_pres.empty?
		#	google_directory.update_members(group_vp, users_vp) unless group_vp.empty?
		#	google_directory.update_members(group_chap, users_chap) unless group_chap.empty?
		#	google_directory.update_members(group_pm, users_pm) unless group_pm.empty?
		#	google_directory.update_members(group_treas, users_treas) unless group_treas.empty?
		#	google_directory.update_members(group_hm, users_hm) unless group_hm.empty?
		#	google_directory.update_members(group_sec, users_sec) unless group_sec.empty?
		#	google_directory.update_members(group_social, users_social) unless group_social.empty?
    	#end

    end

  end
end