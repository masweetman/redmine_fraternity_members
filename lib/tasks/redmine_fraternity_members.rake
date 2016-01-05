namespace :redmine do
  namespace :fraternity_members do

    desc "initializes the member database and adds new members"
    task :initialize => :environment do
		User.where(fraternity_member_id: nil).each do |user|
			user.new_fraternity_member
		end
	end

    desc "Updates the member database"
    task :update => :environment do
		User.where('fraternity_member_id > ?', 0).each do |user|
			unless user.custom_field_value(18).empty?
				phone = ActiveSupport::NumberHelper.number_to_phone(user.custom_field_value(18).gsub(/\D/, '').to_i, area_code: true)
				user.custom_field_values=({'18' => phone.to_s})
			end
			user.update_fraternity_member
		end
    end

  end
end
