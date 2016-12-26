class EmailGroupsController < ApplicationController
	#unloadable

  before_filter :authorize_global, :only => [:new, :create, :copy, :create_org, :edit, :update, :destroy]

	helper :sort
	include SortHelper

  def query
    query = []
    if params[:organization].present?
      query << "organization LIKE '#{params[:organization]}'"
    end
    search_query = ''
    if params[:search].present?
      search = params[:search].split
      query << search.map{ |word| "(organization LIKE '%#{word}%' OR name LIKE '%#{word}%' OR address LIKE '%#{word}%' OR description LIKE '%#{word}%')" }.join(' AND ')
    end
    return query.join(' AND ')
  end

	def index
    sort_init [['organization', 'asc'], ['name', 'asc'], ['address', 'asc']]
    sort_update %w(organization name address)

		@email_groups = EmailGroup.where(query).order(sort_clause)
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

  def copy
    @organizations = EmailGroup.all.map{ |g| g.organization }.compact.uniq.sort
    @projects = Project.find(6).children.map{ |p| p.identifier }.sort
  end

  def create_org
    organization = params['organization']
    new_project_id = Project.find(params['new_project']).id
    new_domain = params['new_domain']

    copy_organization_groups(organization, new_project_id, new_domain)

    redirect_to '/email_groups'
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

    def copy_organization_groups(organization, new_project_id, new_domain)
      email_groups_to_copy = EmailGroup.where(organization: organization)
      old_domain = email_groups_to_copy.first.address.split("@").last

      email_groups_to_copy.each do |email_group|
        new_email_group = email_group.dup
        new_email_group.organization = Project.find(new_project_id).name
        new_email_group.address = email_group.address.gsub(old_domain, new_domain)
        new_email_group.save

        email_group.email_group_memberships.each do |rule|
          new_rule = rule.dup
          new_rule.include_project_id = new_project_id
          new_rule.save
          new_email_group.email_group_memberships << new_rule
        end
      end
    end

		def email_group_params
			params.require(:email_group).permit!
		end

end
