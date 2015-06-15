class GoogleAdminDirectoryWrapper

	def initialize
		@client = Google::APIClient.new(
			:application_name => 'Redmine Fraternity Members',
			:application_version => '3.0.1'
		)
		@directory = @client.discovered_api('admin', 'directory_v1')
		@client_secrets = Google::APIClient::ClientSecrets.load("#{Rails.root}/config/client_secrets.json")
		@flow = Google::APIClient::InstalledAppFlow.new(
			:client_id => @client_secrets.client_id,
			:client_secret => @client_secrets.client_secret,
			:scope => ['https://www.googleapis.com/auth/admin.directory.group']
		)
		@client.authorization = @flow.authorize
		result = @client.execute(:api_method => @directory.groups.list)

		puts result.data

		@email_addresses = settings['email_addresses']
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