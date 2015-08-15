require 'mailer'

module MailerPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
	end

	module InstanceMethods

		def bank_statement(project)
			to_users = [User.find(3)]
			mail :to => to_users, :subject => "Test!"
		end

	end
end

Mailer.send(:include, MailerPatch)
