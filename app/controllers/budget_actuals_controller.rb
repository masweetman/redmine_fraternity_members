class BudgetActualsController < ApplicationController
	#unloadable

	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@budgetCategories = CustomField.find(98).possible_values
		@project = Project.find(params[:id])
		@expenses = @project.issues.where(tracker_id: 22)

		date3 = Date.today
		date2 = Date.today - 1.month
		date1 = Date.today - 2.month

		@date1String = date1.strftime('%b %Y')
		@date2String = date2.strftime('%b %Y')
		@date3String = date3.strftime('%b %Y')

		month1Expenses = {}
		month2Expenses = {}
		month3Expenses = {}
		@quarterExpenses = {}

		for e in @expenses
			expenseDate = Date.parse(e.custom_field_value(28))

			if expenseDate.month == date1.month && expenseDate.year == date1.year
				expenseCategory = e.custom_field_value(98)
				expenseAmount = e.custom_field_value(31).to_f
				if month1Expenses[expenseCategory] == nil then
					month1Expenses[expenseCategory] = expenseAmount
				else
					month1Expenses[expenseCategory] = month1Expenses[expenseCategory] + expenseAmount
				end
			end

			if expenseDate.month == date2.month && expenseDate.year == date2.year
				expenseCategory = e.custom_field_value(98)
				expenseAmount = e.custom_field_value(31).to_f
				if month2Expenses[expenseCategory] == nil then
					month2Expenses[expenseCategory] = expenseAmount
				else
					month2Expenses[expenseCategory] = month2Expenses[expenseCategory] + expenseAmount
				end
			end

			if expenseDate.month == date3.month && expenseDate.year == date3.year
				expenseCategory = e.custom_field_value(98)
				expenseAmount = e.custom_field_value(31).to_f
				if month3Expenses[expenseCategory] == nil then
					month3Expenses[expenseCategory] = expenseAmount
				else
					month3Expenses[expenseCategory] = month3Expenses[expenseCategory] + expenseAmount
				end
			end

		end

		for c in @budgetCategories
			if month1Expenses[c] != nil || month2Expenses[c] != nil || month3Expenses[c] != nil 
				if month1Expenses[c] == nil
					m1 = 0
				else
					m1 = month1Expenses[c]
				end
				if month2Expenses[c] == nil
					m2 = 0
				else
					m2 = month2Expenses[c]
				end
				if month3Expenses[c] == nil
					m3 = 0
				else
					m3 = month3Expenses[c]
				end
				
				@quarterExpenses[c] = [m1,m2,m3]
			end
		end

	end

end