class FinancialsController < ApplicationController

	#unloadable

	helper :sort
	include SortHelper
	helper :custom_fields
	include CustomFieldsHelper
    helper :deposits
    include DepositsHelper

	def index

        @project = Project.find(params[:id])
        
        if @project.parent_id == 6
            @mint_value = mint_value(@project.name)
        end

        if Date.today.month >= 7
            startDate = Date.new(Date.today.year, 7, 1)
            endDate = Date.new(Date.today.year + 1, 6, 30)
            @currentRelativeMonth = Date.today.month - 7
        else
            startDate = Date.new(Date.today.year - 1, 7, 1)
            endDate = Date.new(Date.today.year, 6, 30)
            @currentRelativeMonth = Date.today.month - 7 + 12
        end

        if params[:date].present?
            startDate = Date.new(params[:date][:year].to_i, 7, 1)
            endDate = Date.new(params[:date][:year].to_i + 1, 6, 30)
            @currentRelativeMonth = 12
        end

        @FYStart = startDate

		budgetCategories = CustomField.find(98).possible_values
		@revenue = @project.issues.where('tracker_id = ? AND created_on > ? AND created_on < ?', 26, startDate - 1.month, endDate + 1.month)
        @expenses = @project.issues.where('tracker_id = ? AND status_id <> ? AND created_on > ? AND created_on < ?', 22, 6, startDate - 1.month, endDate + 1.month)
		@latestBudget = @project.issues.where(:tracker_id => 19).last

		@dates = []
		@dateStrings = []
		@annualExpenses = {}
        @annualRevenue = {}

		for i in 0..11
			@dates[i] = startDate + i.month
			@dateStrings[i] = @dates[i].strftime('%b %y')
		end

        for r in @revenue
            if r.custom_field_value(85).empty?
                account = r.custom_field_value(84)
                accountType = "payer"
            else
                account = r.custom_field_value(85)
                accountType = "beneficiary"
            end

            for i in 0..11
                if Date.parse(r.custom_field_value(105)).month == @dates[i].month &&
                   Date.parse(r.custom_field_value(105)).year == @dates[i].year
                    if @annualRevenue[account].nil?
                        @annualRevenue[account] = []
                        @annualRevenue[account][13] = accountType
                    end
                    # sum Monthly values
                    @annualRevenue[account][i] = @annualRevenue[account][i].to_f + r.custom_field_value(104).to_f
                    # sum Total values
                    @annualRevenue[account][12] = @annualRevenue[account][12].to_f + r.custom_field_value(104).to_f
                end
            end
        end
        @annualRevenue = @annualRevenue.sort
				
		for e in @expenses
			for i in 0..11
				if Date.parse(e.custom_field_value(28)).month == @dates[i].month &&
				   Date.parse(e.custom_field_value(28)).year == @dates[i].year &&
				   budgetCategories.include?(e.custom_field_value(98)) then
					if @annualExpenses[e.custom_field_value(98)].nil?
				   		@annualExpenses[e.custom_field_value(98)] = []
					end
                    # sum Monthly values
					@annualExpenses[e.custom_field_value(98)][i] = @annualExpenses[e.custom_field_value(98)][i].to_f + e.custom_field_value(31).to_f
                    # sum Total values
                    @annualExpenses[e.custom_field_value(98)][12] = @annualExpenses[e.custom_field_value(98)][12].to_f + e.custom_field_value(31).to_f
				end
			end
		end
		@annualExpenses = @annualExpenses.sort
	end
  
  def account
    @project = Project.find(params[:id])
    @account = params[:account]

    if Date.today.month >= 7
        startDate = Date.new(Date.today.year, 7, 1)
        endDate = Date.new(Date.today.year + 1, 6, 30)
        @currentRelativeMonth = Date.today.month - 7
    else
        startDate = Date.new(Date.today.year - 1, 7, 1)
        endDate = Date.new(Date.today.year, 6, 30)
        @currentRelativeMonth = Date.today.month - 7 + 12
    end

    if params[:date].present?
        startDate = Date.new(params[:date][:year].to_i, 7, 1)
        endDate = Date.new(params[:date][:year].to_i + 1, 6, 30)
        @currentRelativeMonth = 12
    end

    @FYStart = startDate
    @latestBudget = @project.issues.where(:tracker_id => 19).last
    @dates = []
    @dateStrings = []
    for i in 0..11
        @dates[i] = startDate + i.month
        @dateStrings[i] = @dates[i].strftime('%b %y')
    end

    deposits = @project.issues.where('tracker_id = ? AND created_on > ? AND created_on < ?', 26, startDate - 1.month, endDate + 1.month)
    account_deposits = deposits.joins(:custom_values).where("custom_values.custom_field_id = 85 AND custom_values.value = ?", @account)
    @member_type = account_deposits.last.custom_field_value(86)
    @annual_account_deposits = {}

    for a in account_deposits
        for i in 0..11
            if Date.parse(a.custom_field_value(105)).month == @dates[i].month &&
               Date.parse(a.custom_field_value(105)).year == @dates[i].year
                if @annual_account_deposits['Dues'].nil?
                    @annual_account_deposits['Dues'] = []
                end
                @annual_account_deposits['Dues'][i] = @annual_account_deposits['Dues'][i].to_f + a.custom_field_value(88).to_f
                @annual_account_deposits['Dues'][12] = @annual_account_deposits['Dues'][12].to_f + a.custom_field_value(88).to_f

                if @annual_account_deposits['Rent'].nil?
                    @annual_account_deposits['Rent'] = []
                end
                @annual_account_deposits['Rent'][i] = @annual_account_deposits['Rent'][i].to_f + a.custom_field_value(89).to_f
                @annual_account_deposits['Rent'][12] = @annual_account_deposits['Rent'][12].to_f + a.custom_field_value(89).to_f

                if @annual_account_deposits['Security Deposit'].nil?
                    @annual_account_deposits['Security Deposit'] = []
                end
                @annual_account_deposits['Security Deposit'][i] = @annual_account_deposits['Security Deposit'][i].to_f + a.custom_field_value(120).to_f
                @annual_account_deposits['Security Deposit'][12] = @annual_account_deposits['Security Deposit'][12].to_f + a.custom_field_value(120).to_f

                if @annual_account_deposits['Fines'].nil?
                    @annual_account_deposits['Fines'] = []
                end
                @annual_account_deposits['Fines'][i] = @annual_account_deposits['Fines'][i].to_f + a.custom_field_value(91).to_f
                @annual_account_deposits['Fines'][12] = @annual_account_deposits['Fines'][12].to_f + a.custom_field_value(91).to_f

                if @annual_account_deposits['Other'].nil?
                    @annual_account_deposits['Other'] = []
                end
                @annual_account_deposits['Other'][i] = @annual_account_deposits['Other'][i].to_f + a.custom_field_value(90).to_f
                @annual_account_deposits['Other'][12] = @annual_account_deposits['Other'][12].to_f + a.custom_field_value(90).to_f
            end
        end
    end
  end

  def export
  	index
    totalExpenses = []
    totalRevenue = []

    export_csv = 'Actual Revenue' + "\n"
    export_csv << '"'+'Account'+'"'+','
    for i in 0..11
        export_csv << '"'+@dateStrings[i].to_s+'"'+','
    end
    export_csv << '"TOTAL"'
    export_csv << "\n"
    
    for c in @annualRevenue
        export_csv << '"'+c[0]+'"'+','
        for i in 0..12
            export_csv << '"'+c[1][i].to_f.round.to_s+'"'+','
            totalRevenue[i] = totalRevenue[i].to_f + c[1][i].to_f
        end
        export_csv << "\n"
    end
    export_csv << '"'+'Total Revenue'+'"'+','
    for i in 0..12
        export_csv << '"'+totalRevenue[i].to_f.round.to_s+'"'+','
    end
    export_csv << "\n" + "\n"

    export_csv << 'Actual Expenses' + "\n"
    export_csv << '"'+'Account'+'"'+','
    for i in 0..11
    	export_csv << '"'+@dateStrings[i].to_s+'"'+','
    end
    export_csv << '"TOTAL"'
    export_csv << "\n"
    
    for c in @annualExpenses
    	export_csv << '"'+c[0]+'"'+','
    	for i in 0..12
    		export_csv << '"'+c[1][i].to_f.round.to_s+'"'+','
    		totalExpenses[i] = totalExpenses[i].to_f + c[1][i].to_f
    	end
    	export_csv << "\n"
    end
    export_csv << '"'+'Total Expenses'+'"'+','
    for i in 0..12
    	export_csv << '"'+totalExpenses[i].to_f.round.to_s+'"'+','
    end
    export_csv << "\n" + "\n"

    export_csv << 'Net Cash Flow' + "\n"
    export_csv << '"'+''+'"'+','
        for i in 0..11
    	export_csv << '"'+@dateStrings[i].to_s+'"'+','
    end
    export_csv << '"TOTAL"'
    export_csv << "\n"

    export_csv << '"'+'Net Cash Flow'+'"'+','
    for i in 0..12
    	export_csv << '"'+(totalRevenue[i].to_f - totalExpenses[i].to_f).round.to_s+'"'+','
    end
    
    send_data(export_csv,
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => @project.name + "_budget_actuals_" + Date.today.to_s + ".csv")
  end

  def refresh_mint
    user = Setting.plugin_redmine_fraternity_members['mint_user']
    pw = Setting.plugin_redmine_fraternity_members['mint_pw']

    credentials = Minty::Credentials.new(user,pw)
    client = Minty::Client.new(credentials)
    client.refresh
  end

  def mint_value(chapter)
    begin
        account_name = chapter + ' Account'
        user = Setting.plugin_redmine_fraternity_members['mint_user']
        pw = Setting.plugin_redmine_fraternity_members['mint_pw']

        credentials = Minty::Credentials.new(user,pw)
        client = Minty::Client.new(credentials)

        accounts = client.accounts
        account = accounts.find { |a| a.name == account_name }

        account.value
    rescue Exception => e
        flash[:error] = 'Unable to retrieve account balance from Mint.com. ' + e.message
        return 'error'
    end
  end

  def recent_transactions
    begin
        @project = Project.find(params[:id])
	@latestBudget = @project.issues.where(:tracker_id => 19).last

        account_name = @project.name + ' Account'

        user = Setting.plugin_redmine_fraternity_members['mint_user']
        pw = Setting.plugin_redmine_fraternity_members['mint_pw']

        credentials = Minty::Credentials.new(user,pw)
        client = Minty::Client.new(credentials)

        all_transactions = client.transactions
        @transactions = []
        @transactions = all_transactions.select{ |t| t.json['Account Name'] == account_name }

        @transactions
    rescue Exception => e
        flash[:error] = 'Unable to retrieve data from Mint.com. ' + e.message
        @transactions = []
    end
  end

end
