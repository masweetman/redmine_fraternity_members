# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'directory', :to => 'fraternity_members#index'
get 'directory/export', :to => 'fraternity_members#export'
get '/issues/:id/shingle', :to => 'shingle#shingle_export'