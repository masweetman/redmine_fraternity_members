# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :fraternity_members

resources :email_groups do
  resources :email_group_memberships
end

get '/copy_organization', :to => 'email_groups#copy'
get '/create_organization', :to => 'email_groups#create_org'

get 'directory', :to => 'fraternity_members#index'
get 'directory/export', :to => 'fraternity_members#export'
get 'directory/export_google_contacts', :to => 'fraternity_members#export_google_contacts'
get 'join_group', :to => 'fraternity_members#join_group'

get '/shingles', :to => 'shingle#index'
get '/mark_all_as_shipped', :to => 'shingle#mark_all_as_shipped'
get '/mark_as_shipped', :to => 'shingle#mark_as_shipped'
get '/shingles_invoices', :to => 'shingle#invoices_export_pdf'
get '/issues/:id/shingle_pdf', :to => 'shingle#shingle_export_pdf'
get '/shingles_pdf', :to => 'shingle#shingles_export_pdf'
get '/issues/:id/new_shingle_pdf', :to => 'shingle#new_shingle_export_pdf'
get '/new_shingles_pdf', :to => 'shingle#new_shingles_export_pdf'

get '/projects/:id/financials', :to => 'financials#index'
get '/projects/:id/financials/account', :to => 'financials#account'
get '/projects/:id/financials/export', :to => 'financials#export'
get '/projects/:id/recent_transactions', :to => 'financials#recent_transactions'

get 'crm', :to => 'fraternity_members#crm'
get 'crm/export', :to => 'fraternity_members#export_crm'

get '/projects/:id/deposits', :to => 'deposits#index'

get '/budgets', :to => 'shortcuts#budgets'
get '/chapter-reports', :to => 'shortcuts#chapter_reports'
get '/deposits', :to => 'shortcuts#deposits'
get '/expenses', :to => 'shortcuts#expenses'
get '/minutes', :to => 'shortcuts#minutes'
get '/pin-orders', :to => 'shortcuts#pin_orders'
get '/shingle-orders', :to => 'shortcuts#shingle_orders'
get '/sofs', :to => 'shortcuts#sofs'
get '/officer-sofs', :to => 'shortcuts#officer_sofs'
get '/dues', :to => 'shortcuts#dues'

