class BudgetActualsController < ApplicationController
	#unloadable

	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		budgetCategories = CustomField.find(98).possible_values
		@project = Project.find(params[:id])
		@expenses = @project.issues.where('tracker_id = ? AND created_on > ?', 22, Date.today - 1.year)
		@latestBudget = @project.issues.where(:tracker_id => 19).last

		dates = []
		@dateStrings = []
		@annualExpenses = {}
		for i in 0..11
			dates[i] = Date.today - i.month
			@dateStrings[i] = dates[i].strftime('%b %y')
		end
				
		for e in @expenses
			for i in 0..11
				if Date.parse(e.custom_field_value(28)).month == dates[i].month &&
				   Date.parse(e.custom_field_value(28)).year == dates[i].year &&
				   budgetCategories.include?(e.custom_field_value(98)) then
					if @annualExpenses[e.custom_field_value(98)].nil?
				   		@annualExpenses[e.custom_field_value(98)] = []
					end
					@annualExpenses[e.custom_field_value(98)][i] = @annualExpenses[e.custom_field_value(98)][i].to_f + e.custom_field_value(31).to_f
				end
			end
		end
		@annualExpenses = @annualExpenses.sort
	end

end