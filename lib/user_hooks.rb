module NewUserActionsPlugin
  class Hooks < Redmine::Hook::ViewListener

    def controller_users_success_creation(context={})
      user = context[:user]
      if user.custom_field_value(56).to_i >= Date.current.year
        m = Member.new(:user => user, :roles => [Role.find_by_name('Active')])
        Project.find_by_name(user.custom_field_value(2)).members << m
      end
      if user.custom_field_value(54).downcase == Setting.plugin_redmine_fraternity_members[:fraternity_password].downcase
      	user.activate
      	Mailer.account_activated(user).deliver
      end
    end
  end
end