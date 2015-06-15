class GoogleAdminDirectoryWrapper

	def new
		@client = Google::APIClient.new(
			:application_name => 'Redmine Fraternity Members',
			:application_version => '3.0.1'
		)
		@directory = @client.discovered_api('admin', 'directory_v1')
		google_admin = Setting.plugin_redmine_fraternity_members['google_admin_email']
		key = Google::APIClient::KeyUtils.load_from_pkcs12("#{Rails.root}/config/client.p12", 'notasecret')
		@client.authorization = Signet::OAuth2::Client.new(
		  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
		  :audience => 'https://accounts.google.com/o/oauth2/token',
		  :person => google_admin,
		  :scope => 'https://www.googleapis.com/auth/admin.directory.group',
		  :issuer => '711803943574-27k44uab2s4mp3a15h80oj5eced370a1@developer.gserviceaccount.com',
		  :signing_key => key)
		@client.authorization.fetch_access_token!

		@email_addresses = Setting.plugin_redmine_fraternity_members['email_addresses']
	end

	def get_group
		results = @client.execute(
			:api_method => @directory.groups.get,
			:parameters => {:groupKey => @email_addresses['AAI']},
			:body => nil
			)
	end

	def add_member
		results = @client.execute(
			:api_method => @directory.members.insert,
			:parameters => {:groupKey => @email_addresses['AAI']},
			:body_object => {:email => 'test123@test123.org', :role => 'MEMBER'}
			)
	end

end