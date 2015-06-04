class BudgetActualsController < ApplicationController
	#unloadable

	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper

	def index
		@budgetCategories = CustomField.find(98).possible_values
		@project = Project.find(params[:id])
		@expenses = @project.issues.where('tracker_id = ? AND created_on > ?', 22, Date.today - 1.year)

		date1 = Date.today - 11.month
		date2 = Date.today - 10.month
		date3 = Date.today - 9.month
		date4 = Date.today - 8.month
		date5 = Date.today - 7.month
		date6 = Date.today - 6.month
		date7 = Date.today - 5.month
		date8 = Date.today - 4.month
		date9 = Date.today - 3.month
		date10 = Date.today - 2.month
		date11 = Date.today - 1.month
		date12 = Date.today

		@date1String = date1.strftime('%b %y')
		@date2String = date2.strftime('%b %y')
		@date3String = date3.strftime('%b %y')
		@date4String = date4.strftime('%b %y')
		@date5String = date5.strftime('%b %y')
		@date6String = date6.strftime('%b %y')
		@date7String = date7.strftime('%b %y')
		@date8String = date8.strftime('%b %y')
		@date9String = date9.strftime('%b %y')
		@date10String = date10.strftime('%b %y')
		@date11String = date11.strftime('%b %y')
		@date12String = date12.strftime('%b %y')

		date1Expenses = {}
		date2Expenses = {}
		date3Expenses = {}
		date4Expenses = {}
		date5Expenses = {}
		date6Expenses = {}
		date7Expenses = {}
		date8Expenses = {}
		date9Expenses = {}
		date10Expenses = {}
		date11Expenses = {}
		date12Expenses = {}
		
		@annualExpenses = {}

		for e in @expenses
			expenseDate = Date.parse(e.custom_field_value(28))
			expenseCategory = e.custom_field_value(98)
			expenseAmount = e.custom_field_value(31).to_f

			case
			when expenseDate.month == date1.month && expenseDate.year == date1.year
				if date1Expenses[expenseCategory] == nil then
					date1Expenses[expenseCategory] = expenseAmount
				else
					date1Expenses[expenseCategory] = date1Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date2.month && expenseDate.year == date2.year
				if date2Expenses[expenseCategory] == nil then
					date2Expenses[expenseCategory] = expenseAmount
				else
					date2Expenses[expenseCategory] = date2Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date3.month && expenseDate.year == date3.year
				if date3Expenses[expenseCategory] == nil then
					date3Expenses[expenseCategory] = expenseAmount
				else
					date3Expenses[expenseCategory] = date3Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date4.month && expenseDate.year == date4.year
				if date4Expenses[expenseCategory] == nil then
					date4Expenses[expenseCategory] = expenseAmount
				else
					date4Expenses[expenseCategory] = date4Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date5.month && expenseDate.year == date5.year
				if date5Expenses[expenseCategory] == nil then
					date5Expenses[expenseCategory] = expenseAmount
				else
					date5Expenses[expenseCategory] = date5Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date6.month && expenseDate.year == date6.year
				if date6Expenses[expenseCategory] == nil then
					date6Expenses[expenseCategory] = expenseAmount
				else
					date6Expenses[expenseCategory] = date6Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date7.month && expenseDate.year == date7.year
				if date7Expenses[expenseCategory] == nil then
					date7Expenses[expenseCategory] = expenseAmount
				else
					date7Expenses[expenseCategory] = date7Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date8.month && expenseDate.year == date8.year
				if date8Expenses[expenseCategory] == nil then
					date8Expenses[expenseCategory] = expenseAmount
				else
					date8Expenses[expenseCategory] = date8Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date9.month && expenseDate.year == date9.year
				if date9Expenses[expenseCategory] == nil then
					date9Expenses[expenseCategory] = expenseAmount
				else
					date9Expenses[expenseCategory] = date9Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date10.month && expenseDate.year == date10.year
				if date10Expenses[expenseCategory] == nil then
					date10Expenses[expenseCategory] = expenseAmount
				else
					date10Expenses[expenseCategory] = date10Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date11.month && expenseDate.year == date11.year
				if date11Expenses[expenseCategory] == nil then
					date11Expenses[expenseCategory] = expenseAmount
				else
					date11Expenses[expenseCategory] = date11Expenses[expenseCategory] + expenseAmount
				end
			when expenseDate.month == date12.month && expenseDate.year == date12.year
				if date12Expenses[expenseCategory] == nil then
					date12Expenses[expenseCategory] = expenseAmount
				else
					date12Expenses[expenseCategory] = date12Expenses[expenseCategory] + expenseAmount
				end
			end


		end

		for c in @budgetCategories
			if 	date1Expenses[c] != nil || date2Expenses[c] != nil || date3Expenses[c] != nil ||
				date4Expenses[c] != nil || date5Expenses[c] != nil || date6Expenses[c] != nil ||
				date7Expenses[c] != nil || date8Expenses[c] != nil || date9Expenses[c] != nil ||
				date10Expenses[c] != nil || date11Expenses[c] != nil || date12Expenses[c] != nil
			

				m1 = date1Expenses[c].to_f
				m2 = date2Expenses[c].to_f
				m3 = date3Expenses[c].to_f
				m4 = date4Expenses[c].to_f
				m5 = date5Expenses[c].to_f
				m6 = date6Expenses[c].to_f
				m7 = date7Expenses[c].to_f
				m8 = date8Expenses[c].to_f
				m9 = date9Expenses[c].to_f
				m10 = date10Expenses[c].to_f
				m11 = date11Expenses[c].to_f
				m12 = date12Expenses[c].to_f
				
				@annualExpenses[c] = [m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12]
			end
		end

	end

end