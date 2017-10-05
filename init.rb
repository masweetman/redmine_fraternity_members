require 'googleauth'
require 'google/apis/admin_directory_v1'

require 'httparty'
require 'json'
#require 'minty'

require 'user_hooks'

require_dependency 'registration_patch'
require_dependency 'user_patch'
require_dependency 'user_login_patch'
require_dependency 'mailer_patch'
require_dependency 'member_role_patch'

Redmine::Plugin.register :redmine_fraternity_members do
  name 'Redmine Fraternity Members'
  author 'Mike Sweetman'
  description 'This plugin manages the member database.'
  version '3.5.2'
  url 'https://github.com/masweetman/redmine_fraternity_members.git'
  author_url ''

  redmine_root = Redmine::Utils.relative_url_root
  directory_path = redmine_root + '/directory'
  crm_path = redmine_root + '/crm'

  settings :default => {'empty' => true}, :partial => 'shared/settings'

  project_module :shingle do
    permission :view_shingles, { :shingle => :index }
    permission :print_shingles, { :shingle => [:new_shingle_export_pdf, :new_shingles_export_pdf] }
    permission :ship_shingles, { :shingle => :mark_as_shipped }
    permission :ship_all_shingles, { :shingle => :mark_all_as_shipped }
    permission :modify_signature, { :shingle => :signature_upload }
  end

  project_module :financials do
    permission :view_financials, { :financials => :index }
  end

  project_module :directory do
    permission :export_member_directory, :fraternity_members => [:export, :export_google_contacts]
  end

  project_module :crm do
    permission :view_crm, :fraternity_members => [:crm]
    permission :edit_crm, :fraternity_members => [:edit, :update]
    permission :export_crm, :fraternity_members => [:export_crm]
  end

  project_module :history do
    permission :view_history, { :history => :index }
  end

  menu :top_menu, :fraternity_members, directory_path, :caption => 'Member Directory'
  menu :top_menu, :email_groups, { :controller => 'email_groups', :action => 'index' }, :caption => 'Email Groups'
  menu :top_menu, :wiki, { :controller => 'wiki', :action => 'show', :project_id => 'national', :id => 'wiki' }, :caption => 'Manuals'
  menu :top_menu, :store, { :controller => 'wiki', :action => 'show', :project_id => 'national', :id => 'Store' }, :caption => 'Store'
  menu :top_menu, :downloads, { :controller => 'wiki', :action => 'show', :project_id => 'national', :id => 'Downloads' }, :caption => 'Downloads'
  menu :project_menu, :fraternity_members_crm, { :controller => 'fraternity_members', :action => 'crm'}, :caption => 'CRM', :before => :issues
  menu :project_menu, :financials, { :controller => 'financials', :action => 'index' }, :caption => 'Financials', :after => :activity
  menu :project_menu, :history, { :controller => 'history', :action => 'index' }, :caption => 'History', :after => :wiki
  menu :project_menu, :shingle, { :controller => 'shingle', :action => 'index' }, :caption => 'Shingles', :after => :history
end
