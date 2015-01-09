class FraternityMembersController < ApplicationController
  unloadable

  def index
  	@fraternity_members = FraternityMember.all
  end

end
