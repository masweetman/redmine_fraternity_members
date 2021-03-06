module DepositsHelper

	def link_to_project_deposit_issues_on_date(project, date)
	    link_to date, project_issues_path(project, :set_filter => 1,
		    :tracker_id => 26,
		    :status_id => '*',
		    :cf_105 => date,
		    :c => [:project,:cf_105,:cf_85,:cf_88,:cf_89,:cf_120,:cf_91,:cf_90,:cf_104,:subject,:assigned_to]
	    )
    end

	def link_to_project_deposit_issues_by_account(project, account, accountType)
		if accountType == "payer"
		    link_to account, project_issues_path(project, :set_filter => 1,
			    :tracker_id => 26,
			    :status_id => '*',
			    :cf_84 => account,
			    :c => [:project,:cf_105,:cf_85,:cf_88,:cf_89,:cf_120,:cf_91,:cf_90,:cf_104,:subject,:assigned_to]
		    )
		else
		    link_to account, project_issues_path(project, :set_filter => 1,
			    :tracker_id => 26,
			    :status_id => '*',
			    :cf_85 => account,
			    :c => [:project,:cf_105,:cf_85,:cf_88,:cf_89,:cf_120,:cf_91,:cf_90,:cf_104,:subject,:assigned_to]
		    )
		end
    end

end
