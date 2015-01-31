class FraternityMembersController < ApplicationController
  unloadable

  before_filter :find_role, :only => :index
  before_filter :find_council_member, :only => :export

  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper

  def index
    sort_init 'chapter, active_number', 'asc'
    sort_update %w(chapter active_number lastname pledge_name mail phone address)

    scope = FraternityMember
    scope = scope.where("
      chapter LIKE :chapter AND (
      active_number LIKE :search OR
      firstname LIKE :search OR
      lastname LIKE :search OR
      pledge_name LIKE :search OR
      mail LIKE :search OR
      phone LIKE :search OR
      address LIKE :search)",
      :chapter => "#{params[:chapter]}%",
      :search => "#{params[:search]}%") if params[:chapter].present? or params[:search].present?

    @member_count = scope.count
    @member_pages = Paginator.new @member_count, 100, params['page']
    @offset ||= @member_pages.offset
    @members = scope.offset(@offset).limit(100).order(sort_clause).all

  end

  def export
    if params[:chapter].present? or params[:search].present?
      @fraternity_members = FraternityMember.where("
      chapter LIKE :chapter AND (
      active_number LIKE :search OR
      firstname LIKE :search OR
      lastname LIKE :search OR
      pledge_name LIKE :search OR
      mail LIKE :search OR
      phone LIKE :search OR
      address LIKE :search)",
      :chapter => "#{params[:chapter]}%",
      :search => "#{params[:search]}%")
    else
      @fraternity_members = FraternityMember.all
    end

    @fraternity_members = @fraternity_members.sort_by{|a| [a.chapter, a.active_number]}

    export_csv = 'chapter,active_number,firstname,middlename,lastname,pledge_name,mail,phone,address,graduation_year,active' + "\n"
    @fraternity_members.each do |e|
      export_csv += '"'+e.chapter.to_s+'"'+','+
                    '"'+e.active_number.to_s+'"'+','+
                    '"'+e.firstname.to_s+'"'+','+
                    '"'+e.middlename.to_s+'"'+','+
                    '"'+e.lastname.to_s+'"'+','+
                    '"'+e.pledge_name.to_s+'"'+','+
                    '"'+e.mail.to_s+'"'+','+
                    '"'+e.phone.to_s+'"'+','+
                    '"'+e.address.to_s+'"'+','+
                    '"'+e.graduation_year.to_s+'"'+','+
                    '"'+e.active.to_s+'"'+"\n"
    end
    send_data(export_csv, :type => 'text/csv', :filename => "export.csv")
  end

  private

  def find_role
    Project.all.each do |project|
      # deny access to pledges
      if User.current.roles_for_project(project).include? Role.find(40)
        deny_access
        return
      end
    end
  end

  def find_council_member
    # only allow csv export to National Council members
    unless User.current.member_of? Project.find(6)
      deny_access
      return
    end
  end

end