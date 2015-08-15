namespace :redmine do
  namespace :bank_statements do

    task :send => :environment do
    	project = Project.find('test-project')
    	Mailer.bank_statement(project)
	end

  end
end