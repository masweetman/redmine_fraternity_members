class DepositsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@project = Project.find(params[:id])

		@checks = @project.issues.where('tracker_id = ? AND created_on > ?', 26, Date.today - 2.year)

		@deposits = {}

		for c in @checks
			@deposits[c.custom_field_value(105)] = @deposits[c.custom_field_value(105)].to_f + c.custom_field_value(104).to_f
		end

		@deposits = @deposits.sort.reverse
	end

end