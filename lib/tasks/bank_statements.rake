namespace :redmine do

	task :refresh_mint => :environment do
	    user = Setting.plugin_redmine_fraternity_members['mint_user']
	    pw = Setting.plugin_redmine_fraternity_members['mint_pw']

	    credentials = Minty::Credentials.new(user,pw)
	    client = Minty::Client.new(credentials)
	    client.refresh
	end

	task :send_bank_statements => :environment do
	    user = Setting.plugin_redmine_fraternity_members['mint_user']
	    pw = Setting.plugin_redmine_fraternity_members['mint_pw']

	    credentials = Minty::Credentials.new(user,pw)
	    client = Minty::Client.new(credentials)

	    all_transactions = client.transactions
	    
	    Project.where(parent_id: 6).each do |project|
		    account_name = project.name + ' Account'
		    transactions = []
		    transactions = all_transactions.select{ |t| t.json['Account Name'] == account_name && Date.strptime(t.json['Date'], '%m/%d/%Y').month == (Date.current - 1.month).month && Date.strptime(t.json['Date'], '%m/%d/%Y').year == (Date.current - 1.month).year }
		    if transactions.count > 0
				to_users = []
				project.users.each do |user|
					if user.roles_for_project(project).include?(Role.find_by_name('Treasurer')) ||
						user.roles_for_project(project).include?(Role.find_by_name('President')) ||
						user.roles_for_project(project).include?(Role.find_by_name('Chapter Advisor'))
						to_users << user
					end
				end
				Mailer.bank_statement(project, to_users, transactions).deliver
			end
		end
	end

end