class FraternityMembersController < ApplicationController
  unloadable

  def index
  	@fraternity_members = FraternityMember.all.sort_by{|a| [a.chapter, a.active_number]}
  end

end