Redmine::Plugin.register :redmine_fraternity_members do
  name 'Redmine Fraternity Members'
  author 'Mike Sweetman'
  description 'This plugin manages the member database.'
  version '0.0.1'
  url 'https://github.com/masweetman/redmine_fraternity_members.git'
  author_url ''

menu :top_menu, :fraternity_members, { :controller => 'fraternity_members', :action => 'index'}, :caption => 'Member Directory'

end