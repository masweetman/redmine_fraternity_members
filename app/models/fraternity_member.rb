class FraternityMember < ActiveRecord::Base
	include Redmine::SafeAttributes
	safe_attributes 'firstname', 'middlename', 'lastname', 'mail', 'chapter', 'active_number', 'pledge_name'

	geocoded_by :address
	after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
end
