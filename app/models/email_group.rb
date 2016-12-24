class EmailGroup < ActiveRecord::Base
  has_many :email_group_memberships

  def members
    list = []
    email_group_memberships.each do |email_group_membership|
      list += email_group_membership.members
    end
    return list.uniq
  end

end
