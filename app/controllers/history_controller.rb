class HistoryController < ApplicationController

  helper :sort
  include SortHelper

  def index
    sort_init [['added_on', 'desc'], ['role_id', 'asc']]
    sort_update %w(added_on removed_on role_id user_id)

    @project = Project.find(params[:id])
    if !@project.parent.nil? && @project.parent.id == 6
      @cr = Query.find_by_name("Chapter Reports")
    end

    scope = HistoricalRole.where(project_id: @project.id)
    @roles = Role.all.sort_by{ |r| r.name }
    include_role_ids = [] 
    scope.map{ |hr| include_role_ids << hr.role_id }
    Role.all.each do |r|
      @roles.delete(r) unless include_role_ids.include? r.id
    end

    if params['role']
      scope = scope.where(role_id: params['role'])
      @selected_role = params['role']
    end

    count_per_page = 20
    @role_count = scope.count
    @role_pages = Paginator.new @role_count, count_per_page, params['page']
    @offset ||= @role_pages.offset
    @historical_roles = scope.offset(@offset).limit(count_per_page).order(sort_clause)
  end

end
