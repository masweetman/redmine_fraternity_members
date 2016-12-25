namespace :redmine do
  namespace :google_groups do

    task :update_groups => :environment do

      directory = GoogleDirectory.new

      #add new groups and delete old groups
      directory.update_groups

      #update google group members
      EmailGroup.all.each do |g|
        directory.update_members(g)
      end

    end

  end
end
