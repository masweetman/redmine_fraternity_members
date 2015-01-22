module RedmineFraternityMembers
  module Patches

    module MailerPatch
      module ClassMethods
      end

      module InstanceMethods
		def news_to_all_actives(news)
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

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do
          unloadable
          # TODO: Удалено из-за несовместимости, может быть косяк с шаблонами для майлера
          # self.instance_variable_get("@inheritable_attributes")[:view_paths] << RAILS_ROOT + "/vendor/plugins/redmine_contacts/app/views"
        end
      end
	  
    end

  end
end

unless Mailer.included_modules.include?(RedmineFraternityMembers::Patches::MailerPatch)
  Mailer.send(:include, RedmineFraternityMembers::Patches::MailerPatch)
end
	

		