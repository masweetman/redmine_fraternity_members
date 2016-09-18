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
    	national['Accountant'] = []

    	for user in Project.find(6).users
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl President"))
    			national['Council'] << user.mail
    			national['Exec'] << user.mail
    			national['Pres'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl VP Collegiate"))
    			national['Council'] << user.mail
    			national['Exec'] << user.mail
    			national['VPC'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl VP Alumni"))
    			national['Council'] << user.mail
    			national['Exec'] << user.mail
    			national['VPA'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl Chaplain"))
    			national['Council'] << user.mail
    			national['Exec'] << user.mail
    			national['Chap'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl Treasurer"))
    			national['Council'] << user.mail
    			national['Exec'] << user.mail
    			national['Treas'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Natl Secretary"))
    			national['Council'] << user.mail
    			national['Exec'] << user.mail
    			national['Sec'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - North"))
    			national['Council'] << user.mail
    			national['DC North'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - Central"))
    			national['Council'] << user.mail
    			national['DC Central'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - South"))
    			national['Council'] << user.mail
    			national['DC South'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("DC - Mountain"))
    			national['Council'] << user.mail
    			national['DC Mountain'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("First Herald - LOH"))
    			national['Council'] << user.mail
    		end
    		if user.roles_for_project(Project.find(6)).include?(Role.find_by_name("Accountant"))
    			national['Accountant'] << user.mail
    		end
    	end

    	national['Advisors'] = []
        national['All Chapter Exec'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All Pres'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All VP'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All Chap'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All PM'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All Treas'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All HM'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All Sec'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All Social'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
    	national['All Actives'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]
		
		chapters = {}
		for c in Project.where(:parent_id => 6)
			chapters[c.identifier] = {}
			chapters[c.identifier]['Actives'] = []
			chapters[c.identifier]['Exec'] = []
			chapters[c.identifier]['Advisors'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['National Council']]
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
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['Advisors'] << user.mail
					chapters[c.identifier]['President'] << user.mail
					chapters[c.identifier]['Vice President'] << user.mail
					chapters[c.identifier]['Chaplain'] << user.mail
					chapters[c.identifier]['Pledgemaster'] << user.mail
					chapters[c.identifier]['Treasurer'] << user.mail
					chapters[c.identifier]['House Manager'] << user.mail
					chapters[c.identifier]['Secretary'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("President"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['President'] << user.mail
					chapters[c.identifier]['Vice President'] << user.mail
					chapters[c.identifier]['Chaplain'] << user.mail
					chapters[c.identifier]['Pledgemaster'] << user.mail
					chapters[c.identifier]['Treasurer'] << user.mail
					chapters[c.identifier]['House Manager'] << user.mail
					chapters[c.identifier]['Secretary'] << user.mail
                    chapters[c.identifier]['Social Media Manager'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Vice President"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['Vice President'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Chaplain"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['Chaplain'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Pledgemaster"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['Pledgemaster'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Treasurer"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['Treasurer'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("House Manager"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['House Manager'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Secretary"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Exec'] << user.mail
					chapters[c.identifier]['Secretary'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Social Media Manager"))
					chapters[c.identifier]['Actives'] << user.mail
					chapters[c.identifier]['Social Media Manager'] << user.mail
				end
				if user.roles_for_project(c).include?(Role.find_by_name("Active"))
					chapters[c.identifier]['Actives'] << user.mail
				end
			end

			for group in chapters[c.identifier]
				group[1].uniq!
			end

	    	national['Advisors'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Advisors']
	    	national['All Chapter Exec'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Exec']
	    	national['All Pres'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['President']
	    	national['All VP'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Vice President']
	    	national['All Chap'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Chaplain']
	    	national['All PM'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Pledgemaster']
	    	national['All Treas'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Treasurer']
	    	national['All HM'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['House Manager']
	    	national['All Sec']  << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Secretary']
	    	national['All Social'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Social Media']
	    	national['All Actives'] << Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Actives']
	    	
		end
		
        national['All Alumni Leaders'] = [Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']]

		for group in national
			group[1].uniq!
		end

        alumni_chapters = {}
        for c in Project.where(:parent_id => 50)
            alumni_chapters[c.identifier] = c.users.map{ |u| u.mail }
        end

        alumni_orgs = {}
        for a in Project.where(:parent_id => 36)
            alumni_orgs[a.identifier] = a.users.map{ |u| u.mail }

            national['All Alumni Leaders'] << Setting.plugin_redmine_fraternity_members['ao_email_addresses'][a.identifier] unless Setting.plugin_redmine_fraternity_members['ao_email_addresses'][a.identifier].empty?
        end

        alumni_orgs['AGO Beta Alumni Housing Board'] << Setting.plugin_redmine_fraternity_members['beta_email_addresses']['Beta Exec']

		#add new google groups
		google_directory = GoogleDirectory.new
		google_directory.cache_directory_api_file
		google_directory.update_groups

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Council']
    	emails = national['Council']
    	google_directory.update_members(group, emails)

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Exec']
    	emails = national['Exec']
    	google_directory.update_members(group, emails)

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National President']
    	emails = national['Pres']
    	google_directory.update_members(group, emails)

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['VP Collegiate Chapters']
    	emails = national['VPC']
    	google_directory.update_members(group, emails)

		#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['VP Alumni']
    	emails = national['VPA']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Chaplain']
    	emails = national['Chap']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Treasurer']
    	emails = national['Treas']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['National Secretary']
    	emails = national['Sec']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC North']
    	emails = national['DC North']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC South']
    	emails = national['DC South']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC Central']
    	emails = national['DC Central']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['DC Mountain']
    	emails = national['DC Mountain']
    	google_directory.update_members(group, emails)

    	#update group
		group = Setting.plugin_redmine_fraternity_members['email_addresses']['Accountant']
    	emails = national['Accountant']
    	google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['Chapter Advisors']
        emails = national['Advisors']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Alumni Leaders']
        emails = national['All Alumni Leaders']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Presidents']
        emails = national['All Pres']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Vice Presidents']
        emails = national['All VP']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Chaplains']
        emails = national['All Chap']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Pledgemasters']
        emails = national['All PM']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Treasurers']
        emails = national['All Treas']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All House Managers']
        emails = national['All HM']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Secretaries']
        emails = national['All Sec']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Social Media Managers']
        emails = national['All Social']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Chapter Execs']
        emails = national['All Chapter Exec']
        google_directory.update_members(group, emails)

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Actives']
        emails = national['All Actives']
        google_directory.update_members(group, emails)

    	#update chapter email groups
    	for c in Project.where(:parent_id => 6)
            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Actives']
            emails = chapters[c.identifier]['Actives']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Exec']
            emails = chapters[c.identifier]['Exec']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Advisors']
            emails = chapters[c.identifier]['Advisors']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['President']
            emails = chapters[c.identifier]['President']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Vice President']
            emails = chapters[c.identifier]['Vice President']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Chaplain']
            emails = chapters[c.identifier]['Chaplain']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Pledgemaster']
            emails = chapters[c.identifier]['Pledgemaster']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Treasurer']
            emails = chapters[c.identifier]['Treasurer']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['House Manager']
            emails = chapters[c.identifier]['House Manager']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Secretary']
            emails = chapters[c.identifier]['Secretary']
            google_directory.update_members(group, emails)

            #update group
            group = Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses']['Social Media']
            emails = chapters[c.identifier]['Social Media Manager']
            google_directory.update_members(group, emails)
    	end

        all_alumni_chapter_emails = [Setting.plugin_redmine_fraternity_members['email_addresses']['National Council']]
        for c in Project.where(:parent_id => 50)
            #update group
            group = Setting.plugin_redmine_fraternity_members['ac_email_addresses'][c.identifier]
            emails = alumni_chapters[c.identifier]
            google_directory.update_members(group, emails)

            all_alumni_chapter_emails << Setting.plugin_redmine_fraternity_members['ac_email_addresses'][c.identifier]
        end

        for a in Project.where(:parent_id => 36)
            #update group
            group = Setting.plugin_redmine_fraternity_members['ao_email_addresses'][a.identifier]
            emails = alumni_orgs[a.identifier]
            google_directory.update_members(group, emails)
        end

        #update group
        group = Setting.plugin_redmine_fraternity_members['email_addresses']['All Alumni Chapters']
        google_directory.update_members(group, all_alumni_chapter_emails)

    end

  end
end
