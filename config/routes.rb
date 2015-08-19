# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :fraternity_members

get 'directory', :to => 'fraternity_members#index'
get 'directory/export', :to => 'fraternity_members#export'
get 'directory/export_google_contacts', :to => 'fraternity_members#export_google_contacts'

get '/shingles_pdf', :to => 'shingle#shingles_export_pdf'
get '/issues/:id/shingle_html', :to => 'shingle#shingle_export_html'
get '/issues/:id/shingle_pdf', :to => 'shingle#shingle_export_pdf'

get '/projects/:id/budget_actuals', :to => 'budget_actuals#index'
get '/projects/:id/budget_actuals/export', :to => 'budget_actuals#export'
get '/projects/:id/recent_transactions', :to => 'budget_actuals#recent_transactions'

get '/projects/:id/deposits', :to => 'deposits#index'

get 'email_groups', :to => 'email_groups#index'
get 'email_groups/:group', :to => 'email_groups#show'