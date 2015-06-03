class FraternityMember < ActiveRecord::Base
	include Redmine::SafeAttributes
	safe_attributes 'firstname', 'middlename', 'lastname', 'mail', 'chapter', 'active_number', 'pledge_name'
end
