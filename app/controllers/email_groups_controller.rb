class EmailGroupsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@chapters = Project.where(:parent_id => 6).sort
		@alumni_orgs = Project.where(:parent_id => 36).sort
		@alumni_chapters = Project.where(:parent_id => 50).sort
	end

	def show
		@group = params[:group]
		@chapter = params[:chapter]

		if @chapter.nil? || @chapter.empty?
			@email = Setting.plugin_redmine_fraternity_members['email_addresses'][@group]
		elsif Project.find(@chapter).parent_id == 50
			@email = Setting.plugin_redmine_fraternity_members['ac_email_addresses'][@chapter]
		elsif Project.find(@chapter).parent_id == 36
			@email = Setting.plugin_redmine_fraternity_members['ao_email_addresses'][@chapter]
		elsif Project.find(@chapter).parent_id == 6
			@email = Setting.plugin_redmine_fraternity_members[@chapter + '_email_addresses'][@group]
		end
			

		google_directory = GoogleDirectory.new
		@members = google_directory.list_members(@email)
		
	end
end
