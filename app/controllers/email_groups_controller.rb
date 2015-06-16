class EmailGroupsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@chapters = Project.where(:parent_id => 6).sort
	end
end