class FraternityMember < ActiveRecord::Base
	include Redmine::SafeAttributes
	safe_attributes 'chapter'
end
