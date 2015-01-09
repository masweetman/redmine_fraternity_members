# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'directory', :to => 'fraternity_members#index'
get 'directory/:sort_criteria', :to => 'fraternity_members#index'