class EmailGroupsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@chapters = Project.where(:parent_id => 6).sort
	end

	def show
		@group = params[:group]
		@chapter = params[:chapter]

		if @chapter.nil?
			@email = Setting.plugin_redmine_fraternity_members['email_addresses'][@group]
		else
			@email = Setting.plugin_redmine_fraternity_members[@chapter + '_email_addresses'][@group]
		end

		google_directory = GoogleDirectory.new
		@members = google_directory.list_members(@email)
		
	end
end