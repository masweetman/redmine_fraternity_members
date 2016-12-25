class EmailGroupMembershipsController < ApplicationController
  #unloadable

  before_filter :authorize_global, :only => [:new, :create, :edit, :update, :destroy]
  
  helper :sort
  include SortHelper

  def new
    @email_group = EmailGroup.find(params[:email_group_id])
    @email_group_membership = EmailGroupMembership.new
  end

  def create
    @email_group = EmailGroup.find(params[:email_group_id])
    @email_group_membership = @email_group.email_group_memberships.create(email_group_membership_params)

    if @email_group_membership.save
      redirect_to @email_group
    else
      render 'new'
    end
  end

  def edit
    @email_group = EmailGroup.find(params[:email_group_id])
    @email_group_membership = EmailGroupMembership.find(params[:id])
  end

  def update
    @email_group = EmailGroup.find(params[:email_group_id])
    @email_group_membership = EmailGroupMembership.find(params[:id])

    if @email_group_membership.update(email_group_membership_params)
      redirect_to @email_group
    else
      render 'edit'
    end
  end

  def destroy
    @email_group_membership = EmailGroupMembership.find(params[:id])
    @email_group = EmailGroup.find(@email_group_membership.email_group_id)

    @email_group_membership.destroy
    redirect_to @email_group
    flash[:notice] = l(:notice_successful_delete)
  end

  private

    def email_group_membership_params
      params.require(:email_group_membership).permit!
    end

end
