module UserLoginPatch
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      class << self
        alias_method_chain :find_by_login, :mail_login
      end
    end
  end

  module ClassMethods

    def find_by_login_with_mail_login(login)
      user = find_by_login_without_mail_login(login)
      unless user
        if login.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/)
          user = find_by_mail(login)
        end
      end
      user
    end

  end

end

User.send :include, UserLoginPatch