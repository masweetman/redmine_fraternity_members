#require 'redmine'

require 'registration_hooks'

require_dependency 'user_patch'
require_dependency 'news_patch'
require_dependency 'mailer_patch'

Redmine::Plugin.register :redmine_fraternity_members do
  name 'Redmine Fraternity Members'
  author 'Mike Sweetman'
  description 'This plugin manages the member database.'
  version '0.0.1'
  url 'https://github.com/masweetman/redmine_fraternity_members.git'
  author_url ''

  redmine_root = Redmine::Utils.relative_url_root
  directory_path = redmine_root + '/directory'

  menu :top_menu, :fraternity_members, { :controller => 'fraternity_members', :action => 'index'}, :caption => 'Member Directory'
  settings :default => {:actives_only => ""}, :partial => 'shared/settings'

  permission :export_member_directory, :fraternity_members => :export

end
