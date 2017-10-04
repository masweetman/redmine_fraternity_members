class HistoryController < ApplicationController

  helper :sort
  include SortHelper

  def index
    sort_init [['added_on', 'desc'], ['role', 'asc']]
    sort_update %w(added_on removed_on role user)

    @project = Project.find(params[:id])
    @historical_roles = HistoricalRole.where(project_id: @project.id)
  end

end