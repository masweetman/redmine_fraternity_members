class GoogleDirectory

	#usage:
	# google_directory = GoogleDirectory.new
	# google_directory.cache_directory_api_file
	# group = google_directory.get_group('test@test.com')
	# etc...

	def cache_directory_api_file
		File.open(directory_api_file, 'w') do |f|
			f.puts MultiJson.dump(client.discovery_document('admin', 'directory_v1'))
		end
	end

	def directory_api_file
		"#{Rails.root}/config/google_directory_api.json"
	end

	def client_pt12
		"#{Rails.root}/config/client.p12"
	end

	def client
		client = Google::APIClient.new(
			:application_name => 'Redmine Fraternity Members',
			:application_version => '3.0.1'
		)

		google_admin = Setting.plugin_redmine_fraternity_members['google_admin_email']
		key = Google::APIClient::KeyUtils.load_from_pkcs12(client_pt12, 'notasecret')
		client.authorization = Signet::OAuth2::Client.new(
		  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
		  :audience => 'https://accounts.google.com/o/oauth2/token',
		  :person => google_admin,
		  :scope => 'https://www.googleapis.com/auth/admin.directory.group',
		  :issuer => '711803943574-27k44uab2s4mp3a15h80oj5eced370a1@developer.gserviceaccount.com',
		  :signing_key => key)

		client.authorization.fetch_access_token!
		client
	end

	def google_directory_api
		doc = File.read(directory_api_file)
		client.register_discovery_document('admin', 'directory_v1', doc)
		google_directory_api = client.discovered_api('admin', 'directory_v1')
	end

	def update_groups
		email_addresses = Setting.plugin_redmine_fraternity_members['email_addresses']
		for c in Project.where(:parent_id => 6)
			email_addresses = email_addresses.merge(Setting.plugin_redmine_fraternity_members[c.identifier + '_email_addresses'])
		end
		email_addresses = email_addresses.merge(Setting.plugin_redmine_fraternity_members['ac_email_addresses'])
		email_addresses = email_addresses.merge(Setting.plugin_redmine_fraternity_members['ao_email_addresses'])
		
		email_addresses.delete_if{ |g, e| e.empty? }
		google_groups = list_groups
		for e in email_addresses do
			unless google_groups.include?(e[1])
				create_group(e[1], e[0])
			end
		end
	end

	def create_group(groupEmailAddress, groupName)
		client.execute(
			:api_method => google_directory_api.groups.insert,
			:parameters => {:group => groupEmailAddress},
			:body_object => {:email => groupEmailAddress, :name => groupName}
			)
	end

	def group_exists?(groupEmailAddress)
		results = client.execute(
			:api_method => google_directory_api.groups.get,
			:parameters => {:groupKey => groupEmailAddress},
			:body => nil
			)
		exists = true
		if results.error?
			results = JSON.parse(results.body)
			if results['error']['code'] == 404
				exists = false
			end
		end
		exists
	end

	def list_groups
		results = client.execute(
			:api_method => google_directory_api.groups.list,
			:parameters => {:customer => 'my_customer'},
			:body => nil
			)
		results = JSON.parse(results.body)
		if results['groups'].nil?
			results = []
		else
			results = results['groups'].map{ |m| m['email'] }
		end
		results
	end

	def list_members(groupEmailAddress)
		results = client.execute(
			:api_method => google_directory_api.members.list,
			:parameters => {:groupKey => groupEmailAddress},
			:body => nil
			)
		results = JSON.parse(results.body)
		if results['members'].nil?
			results = []
		else
			results = results['members'].map{ |m| m['email'] }
		end
		results
	end

	def update_members(groupEmailAddress, new_emails)
		unless groupEmailAddress.nil? or groupEmailAddress.empty? or new_emails.nil?

			new_emails.delete("")
			current_emails = list_members(groupEmailAddress)
			unless new_emails.sort == current_emails.sort
				delete_emails = current_emails - new_emails
				add_emails = new_emails - current_emails
				for d in delete_emails
					client.execute(
						:api_method => google_directory_api.members.delete,
						:parameters => {:groupKey => groupEmailAddress, :memberKey => d},
						:body => nil
						)
				end
				for a in add_emails
					client.execute(
						:api_method => google_directory_api.members.insert,
						:parameters => {:groupKey => groupEmailAddress},
						:body_object => {:email => a, :role => 'MEMBER'}
						)
				end
			end

		end
	end

end