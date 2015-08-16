namespace :redmine do

	task :send_bank_statements => :environment do
	    user = Setting.plugin_redmine_fraternity_members['mint_user']
	    pw = Setting.plugin_redmine_fraternity_members['mint_pw']

	    credentials = Minty::Credentials.new(user,pw)
	    client = Minty::Client.new(credentials)
	    client.refresh

	    all_transactions = client.transactions
	    
	    Project.where(parent_id: 6).each do |project|
		    account_name = project.name + ' Account'
		    transactions = []
		    transactions = all_transactions.select{ |t| t.json['Account Name'] == account_name && Date.strptime(t.json['Date'], '%m/%d/%Y').month == (Date.current - 1.month).month && Date.strptime(t.json['Date'], '%m/%d/%Y').year == (Date.current - 1.month).year }
		    if transactions.count > 0
				Mailer.bank_statement(project, transactions).deliver
			end
		end
	end

end