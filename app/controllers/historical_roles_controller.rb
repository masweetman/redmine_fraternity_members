class HistoricalRolesController < ApplicationController

  def destroy
    @role = HistoricalRole.find(params[:id])
    @project = Project.find(@role.project_id)
    @role.destroy
    redirect_to controller: 'history', action: 'index', id: @project
    flash[:notice] = l(:notice_successful_delete)
  end

end
