require 'google/api_client'
require 'google/api_client/service'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'httparty'
require 'json'
require 'minty'

require 'user_hooks'

require_dependency 'registration_patch'
require_dependency 'user_patch'
require_dependency 'mailer_patch'

Redmine::Plugin.register :redmine_fraternity_members do
  name 'Redmine Fraternity Members'
  author 'Mike Sweetman'
  description 'This plugin manages the member database.'
  version '3.5.2'
  url 'https://github.com/masweetman/redmine_fraternity_members.git'
  author_url ''

  redmine_root = Redmine::Utils.relative_url_root
  directory_path = redmine_root + '/directory'

  settings :default => {'empty' => true}, :partial => 'shared/settings'

  permission :export_member_directory, :fraternity_members => [:export, :export_google_contacts]
  permission :edit_fraternity_members, :fraternity_members => [:edit, :update]

  project_module :financials do
    permission :view_financials, { :financials => :index }
  end

  menu :top_menu, :fraternity_members, directory_path, :caption => 'Member Directory'
  menu :top_menu, :email_groups, { :controller => 'email_groups', :action => 'index' }, :caption => 'Email Groups'
  menu :top_menu, :wiki, { :controller => 'wiki', :action => 'show', :project_id => 'national', :id => 'wiki' }, :caption => 'Manuals'
  menu :project_menu, :financials, { :controller => 'financials', :action => 'index' }, :caption => 'Financials', :after => :activity

end
