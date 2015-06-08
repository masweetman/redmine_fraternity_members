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

		@dates = []
		@dateStrings = []
		@annualExpenses = {}
		@annualDeposits = []

		for i in 0..11
			@dates[i] = Date.today - i.month
			@dateStrings[i] = @dates[i].strftime('%b %y')
		end

		for d in @deposits
			for i in 0..11
				if Date.parse(d.custom_field_value(19)).month == @dates[i].month &&
				   Date.parse(d.custom_field_value(19)).year == @dates[i].year then
					@annualDeposits[i] = @annualDeposits[i].to_f + d.custom_field_value(94).to_f
				end
			end
		end
				
		for e in @expenses
			for i in 0..11
				if Date.parse(e.custom_field_value(28)).month == @dates[i].month &&
				   Date.parse(e.custom_field_value(28)).year == @dates[i].year &&
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

  def export
  	index

    export_csv = 'Actual Revenue' + "\n"
    export_csv << '"'+''+'"'+','
    for j in 0..11
    	i = 11 - j
    	export_csv << '"'+@dateStrings[i].to_s+'"'+','
    end
    export_csv << "\n"
    export_csv << '"'+'Total Deposits'+'"'+','
    for j in 0..11
    	i = 11 - j
    	export_csv << '"'+@annualDeposits[i].to_f.round.to_s+'"'+','
    end
    export_csv << "\n" + "\n"

    export_csv << 'Actual Expenses' + "\n"
    export_csv << '"'+''+'"'+','
        for j in 0..11
    	i = 11 - j
    	export_csv << '"'+@dateStrings[i].to_s+'"'+','
    end
    export_csv << "\n"
    totalExpenses = []
    for c in @annualExpenses
    	export_csv << '"'+c[0]+'"'+','
    	for j in 0..11
    		i = 11 - j
    		export_csv << '"'+c[1][i].to_f.round.to_s+'"'+','
    		totalExpenses[i] = totalExpenses[i].to_f + c[1][i].to_f
    	end
    	export_csv << "\n"
    end
    export_csv << '"'+'Total'+'"'+','
    for j in 0..11
    	i = 11 - j
    	export_csv << '"'+totalExpenses[i].round.to_s+'"'+','
    end
    export_csv << "\n" + "\n"

    export_csv << 'Net Cash Flow' + "\n"
    export_csv << '"'+''+'"'+','
        for j in 0..11
    	i = 11 - j
    	export_csv << '"'+@dateStrings[i].to_s+'"'+','
    end
    export_csv << "\n"
    export_csv << '"'+'Net Cash Flow'+'"'+','
    for j in 0..11
    	i = 11 - j
    	export_csv << '"'+(@annualDeposits[i].to_f.round - totalExpenses[i].round).to_s+'"'+','
    end
    
    send_data(export_csv,
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => @project.name + "_budget_actuals_" + Date.today.to_s + ".csv")
  end

end