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

end