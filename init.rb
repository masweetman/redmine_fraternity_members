require 'user_hooks'

require_dependency 'registration_patch'
require_dependency 'user_patch'
require_dependency 'news_patch'
require_dependency 'mailer_patch'

Redmine::Plugin.register :redmine_fraternity_members do
  name 'Redmine Fraternity Members'
  author 'Mike Sweetman'
  description 'This plugin manages the member database.'
  version '1.0.0'
  url 'https://github.com/masweetman/redmine_fraternity_members.git'
  author_url ''

  redmine_root = Redmine::Utils.relative_url_root
  directory_path = redmine_root + '/directory'

  menu :top_menu, :fraternity_members, { :controller => 'fraternity_members', :action => 'index'}, :caption => 'Member Directory'
  menu :top_menu, :wiki, { :controller => 'wiki', :action => 'show', :project_id => 'chapters', :id => 'wiki' }, :caption => 'National Wiki'
  menu :top_menu, :news, { :controller => 'news', :action => 'index', :project_id => 'chapters' }, :caption => 'National News'

  settings :default => {:actives_only => ""}, :partial => 'shared/settings'

  permission :export_member_directory, :fraternity_members => [:export, :export_google_contacts]

end
