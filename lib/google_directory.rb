class GoogleDirectory

	#usage:
	# google_directory = GoogleDirectory.new
	# group = google_directory.get_group('test@test.com')
	# etc...

	def new
		cache_directory_api_file
	end

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
		@email_addresses = Setting.plugin_redmine_fraternity_members['email_addresses']
		i=0
		for e in @email_addresses do
			group = get_group(e[1])
			if group.error?
				i = i+1 if group.data.error['errors'].first['reason']=='notFound'
			end
		end
		return i
	end

	def get_group(groupEmailAddress)
		results = client.execute(
			:api_method => google_directory_api.groups.get,
			:parameters => {:groupKey => groupEmailAddress},
			:body => nil
			)
	end

	def list_members(groupEmailAddress)
		results = client.execute(
			:api_method => google_directory_api.members.list,
			:parameters => {:groupKey => groupEmailAddress},
			:body => nil
			)
		results = JSON.parse(results.body)
		results = results['members'].map{ |m| m['email'] }
	end

	def add_member(groupEmailAddress, memberEmailAddress)
		results = client.execute(
			:api_method => google_directory_api.members.insert,
			:parameters => {:groupKey => groupEmailAddress},
			:body_object => {:email => memberEmailAddress, :role => 'MEMBER'}
			)
	end

end