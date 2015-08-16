require 'mailer'

module MailerPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
        base.class_eval do 
          unloadable   
        end  
	end

	module InstanceMethods

		def bank_statement(project, to_users, transactions)
			@transactions = transactions
			@statement_date = (Date.today - 1.month).strftime("%B %Y")

			mail :to => to_users, :subject => "#{project.name} Chase Bank Transactions - #{@statement_date}"
		end

	end
end

Mailer.send(:include, MailerPatch)
