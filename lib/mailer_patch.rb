require 'mailer'

module MailerPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			belongs_to :deliverable

			alias_method_chain :news_added, :all_actives
		end
	end

	module InstanceMethods

		def news_added_with_all_actives(news)
			actives = news.recipients
			while actives.count > 0 do
				mail_batch = actives.pop(99)

				redmine_headers 'Project' => news.project.identifier
				@author = news.author
				message_id news
				references news
				@news = news
				@news_url = url_for(:controller => 'news', :action => 'show', :id => news)
				mail(:to => ["slosweetman@gmail.com"], :subject => "[#{news.project.name}] #{l(:label_news)}: #{news.title}").deliver
			end
		end

	end
end

Mailer.send(:include, MailerPatch)
