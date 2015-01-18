class FraternityMembersController < ApplicationController
  unloadable
  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper

  def index
    sort_init 'chapter', 'asc'
    sort_update %w(chapter active_number lastname pledge_name mail phone address)

    scope = FraternityMember

    @member_count = scope.count
    @member_pages = Paginator.new @member_count, 100, params['page']
    @offset ||= @member_pages.offset
    @members = scope.offset(@offset).limit(100).order(sort_clause).all

  end

  def export
    @fraternity_members = FraternityMember.all.sort_by{|a| [a.chapter, a.active_number]}
    export_csv = 'chapter,active_number,firstname,middlename,lastname,pledge_name,mail,phone,address,graduation_year,active' + "\n"
    @fraternity_members.each do |e|
      export_csv += e.chapter.to_s+','+e.active_number.to_s+','+e.firstname.to_s+','+e.middlename.to_s+','+e.lastname.to_s+','+e.pledge_name.to_s+','+e.mail.to_s+','+e.phone.to_s+','+e.address.to_s+','+e.graduation_year.to_s+','+e.active.to_s + "\n"
    end
    send_data(export_csv, :type => 'text/csv', :filename => "export.csv")
  end

end