class EmailGroupsController < ApplicationController
	#unloadable
	helper :sort
	include SortHelper

	def index
    sort_init [['organization', 'asc'], ['name', 'asc'], ['address', 'asc']]
    sort_update %w(organization name address)

		@email_groups = EmailGroup.all.order(sort_clause)

		#this stuff will be deleted eventually
		@chapters = Project.where(:parent_id => 6).sort
		@alumni_orgs = Project.where(:parent_id => 36).sort
		@alumni_chapters = Project.where(:parent_id => 50).sort
	end

	def new
		@email_group = EmailGroup.new
	end

	def create
		@email_group = EmailGroup.new(email_group_params)

		if @email_group.save
			redirect_to @email_group
		else
			render 'new'
		end
	end

	def edit
		@email_group = EmailGroup.find(params[:id])
	end

	def update
		@email_group = EmailGroup.find(params[:id])

		if @email_group.update(email_group_params)
			redirect_to @email_group
		else
			render 'edit'
		end
	end

	def show
    sort_init [['include_project_id', 'asc'], ['include_role_id', 'asc']]
    sort_update %w(project role)

		@email_group = EmailGroup.find(params[:id])
    @email_group_membership = EmailGroupMembership.new
		@email_group_memberships = @email_group.email_group_memberships.order(sort_clause)
	end

  def destroy
    @email_group = EmailGroup.find(params[:id])

    @email_group.email_group_memberships.each do |membership|
    	membership.destroy
    end
    @email_group.destroy
    redirect_to '/email_groups'
    flash[:notice] = l(:notice_successful_delete)
  end

	private

		def email_group_params
			params.require(:email_group).permit!
		end

end
