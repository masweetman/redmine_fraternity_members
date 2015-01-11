class FraternityMembersController < ApplicationController
  unloadable
  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper

  def index
    sort = params[:sort]
    case sort
    when 'firstname' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.firstname.downcase]}
    when 'lastname' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.lastname.downcase]}
    when 'pledge_name' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.pledge_name.downcase]}
    when 'zip' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.address]}
    else @fraternity_members = FraternityMember.all.sort_by{|a| [a.chapter, a.active_number]}
    end
  end

  def export
    export_csv = 'chapter,active_number,firstname,middlename,lastname,pledge_name,mail,phone,address,graduation_year,active' + "\n"
    @fraternity_members.each do |e|
      export_csv += e.chapter+','+e.active_number+','+e.firstname+','+e.middlename+','+e.lastname+','+e.pledge_name+','+e.mail+','+e.phone+','+e.address+','+e.graduation_year+','+e.active + "\n"
    end

    send_data(export_csv, :type => 'text/html', :filename => "export.csv")

  end

end