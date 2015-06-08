# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :fraternity_members

get 'directory', :to => 'fraternity_members#index'
get 'directory/export', :to => 'fraternity_members#export'
get 'directory/export_google_contacts', :to => 'fraternity_members#export_google_contacts'
get '/issues/:id/shingle', :to => 'shingle#shingle_export'
get '/projects/:id/budget_actuals', :to => 'budget_actuals#index'
get '/projects/:id/budget_actuals/export', :to => 'budget_actuals#export'