class ShortcutsController < ApplicationController

  def budgets
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Budgets').id
  end
  def chapter_reports
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Chapter Reports').id
  end
  def deposits
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Deposits').id
  end
  def expenses
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Expenses').id
  end
  def minutes
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Minutes').id
  end
  def pin_orders
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Pin Orders').id
  end
  def shingle_orders
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Shingle Orders').id
  end
  def sofs
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('SOFs').id
  end
  def officer_sofs
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('SOFs - Approved Officers').id
  end
  def dues
    redirect_to controller: 'issues', action: 'index', query_id: Query.find_by_name('Unpaid Dues').id
  end

end
