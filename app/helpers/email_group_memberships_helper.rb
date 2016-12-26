module EmailGroupMembershipsHelper

  def projects_list
    list = {}
    Project.all.order(:name).map{ |p| list[p.name] = p.id }
    return list
  end

  def roles_list
    list = {}
    Role.all.order(:name).map{ |r| list[r.name] = r.id }
    return list
  end

  def email_groups_list
    list = {}
    EmailGroup.all.order(:address).map{ |g| list[g.address] = g.id }
    return list
  end

end