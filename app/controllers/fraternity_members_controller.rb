class FraternityMembersController < ApplicationController
  unloadable
  helper :queries
  include QueriesHelper

  def index
    sort = params[:sort]
    case sort
    when 'firstname' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.firstname]}
    when 'lastname' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.lastname]}
    when 'zip' then @fraternity_members = FraternityMember.all.sort_by{|a| [a.address]}
    else @fraternity_members = FraternityMember.all.sort_by{|a| [a.chapter, a.active_number]}
    end
  end

end