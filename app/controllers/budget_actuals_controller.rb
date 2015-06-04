class BudgetActualsController < ApplicationController
	#unloadable

	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		budgetCategories = CustomField.find(98).possible_values
		@project = Project.find(params[:id])
		@expenses = @project.issues.where('tracker_id = ? AND status_id <> ? AND created_on > ?', 22, 6, Date.today - 1.year)
		@deposits = @project.issues.where('tracker_id = ? AND created_on > ?', 21, Date.today - 1.year)
		@latestBudget = @project.issues.where(:tracker_id => 19).last

		dates = []
		@dateStrings = []
		@annualExpenses = {}
		@annualDeposits = []

		for i in 0..11
			dates[i] = Date.today - i.month
			@dateStrings[i] = dates[i].strftime('%b %y')
		end

		for d in @deposits
			for i in 0..11
				if Date.parse(d.custom_field_value(19)).month == dates[i].month &&
				   Date.parse(d.custom_field_value(19)).year == dates[i].year then
					@annualDeposits[i] = @annualDeposits[i].to_f + d.custom_field_value(94).to_f
				end
			end
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