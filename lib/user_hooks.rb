module NewUserActionsPlugin
  class Hooks < Redmine::Hook::ViewListener

    def controller_user_created_or_updated(context={})
      user = context[:user]
      if (user.active? && user.custom_field_value(56).to_i >= Date.current.year && user.projects.empty?)
        m = Member.new(:user => user, :roles => [Role.find_by_name('Active')])
        if !Project.find_by_name(user.custom_field_value(2)).nil?
          Project.find_by_name(user.custom_field_value(2)).members << m
        end
      end
      
      unless user.custom_field_value(18).empty?
        phone = number_to_phone(user.custom_field_value(18).gsub(/\D/, '').to_i, area_code: true)
        user.custom_field_values=({'18' => phone.to_s})
      end
      user.new_fraternity_member
      user.update_fraternity_member
    end
    
  end
end
