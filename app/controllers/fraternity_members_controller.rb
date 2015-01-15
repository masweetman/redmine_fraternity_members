class FraternityMembersController < ApplicationController
  unloadable
  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper

  def index
    sort = params[:sort]
    case sort
    when 'firstname' then @fraternity_members = FraternityMember.where('firstname != ?', '').sort_by{|a| [a.firstname.downcase]}
    when 'lastname' then @fraternity_members = FraternityMember.where('lastname != ?', '').sort_by{|a| [a.lastname.downcase]}
    when 'pledge_name' then @fraternity_members = FraternityMember.where('pledge_name != ?', '').sort_by{|a| [a.pledge_name.downcase]}
    when 'zip' then @fraternity_members = FraternityMember.where('address != ?', '').sort_by{|a| [a.address]}
    else @fraternity_members = FraternityMember.all.sort_by{|a| [a.chapter, a.active_number]}
    end
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