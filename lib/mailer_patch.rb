require 'mailer'

module MailerPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
        base.class_eval do 
          unloadable   
        end  
	end

	module InstanceMethods

		def bank_statement(project, transactions)
			@transactions = transactions
			@statement_date = (Date.today - 1.month).strftime("%B %Y")
			to_users = []

			project.users.each do |user|
				if user.roles_for_project(project).include?(Role.find_by_name('Treasurer')) ||
					user.roles_for_project(project).include?(Role.find_by_name('President')) ||
					user.roles_for_project(project).include?(Role.find_by_name('Chapter Advisor'))
					to_users << user
				end
			end

			mail :to => to_users, :subject => "#{project.name} Chase Bank Transactions - #{@statement_date}"
		end

	end
end

Mailer.send(:include, MailerPatch)
