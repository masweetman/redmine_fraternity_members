module DepositsHelper

	def link_to_project_deposit_issues_on_date(project, date)
	    link_to date, project_issues_path(project, :set_filter => 1,
		    :tracker_id => 26,
		    :status_id => '*',
		    :cf_105 => date,
		    :c => [:tracker,:cf_105,:cf_84,:cf_85,:cf_88,:cf_89,:cf_91,:cf_90,:cf_104]
	    )
    end

	def link_to_project_deposit_issues_by_account(project, account, accountType)
		if accountType == "payer"
		    link_to account, project_issues_path(project, :set_filter => 1,
			    :tracker_id => 26,
			    :status_id => '*',
			    :cf_84 => account,
			    :c => [:tracker,:cf_105,:cf_84,:cf_85,:cf_88,:cf_89,:cf_91,:cf_90,:cf_104]
		    )
		else
		    link_to account, project_issues_path(project, :set_filter => 1,
			    :tracker_id => 26,
			    :status_id => '*',
			    :cf_85 => account,
			    :c => [:tracker,:cf_105,:cf_84,:cf_85,:cf_88,:cf_89,:cf_91,:cf_90,:cf_104]
		    )
		end
    end

end
