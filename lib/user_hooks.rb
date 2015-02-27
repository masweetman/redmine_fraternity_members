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

      user.new_fraternity_member
      user.update_fraternity_member
    end
    
  end
end