class BudgetActualsController < ApplicationController
	#unloadable

	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@project = Project.find(params[:id])
	end

end