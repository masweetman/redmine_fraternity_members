class GoogleDirectory

  def google_admin_user
    Setting.plugin_redmine_fraternity_members['google_admin_email']
  end

  def google_customer_id
    Setting.plugin_redmine_fraternity_members['google_customer_id']
  end

  def directory
    scope = ['https://www.googleapis.com/auth/admin.directory.group']
    authorization = Google::Auth.get_application_default(scope)

    auth_client = authorization.dup
    auth_client.sub = google_admin_user

    auth_client.fetch_access_token!

    directory = Google::Apis::AdminDirectoryV1::DirectoryService.new
    directory.authorization = auth_client

    directory
  end

  def list_groups_from_google
    response = directory.list_groups(customer: google_customer_id)
    if response.groups.nil?
      raise 'Error getting groups from Google.'
    else
      return response.groups.map{ |g| g.email }.sort
    return list
  end

  def list_members(email_group)
    response = directory.list_members(email_group.address)
    if response.members.nil?
      raise 'Error getting members from Google Group: ' + email_group.address
    else
      return response.members.map{ |m| m.email }.sort
    end
  end

  def update_groups
    google_groups = list_groups_from_google
    redmine_groups = EmailGroup.all.map{ |g| g.address.downcase }.sort

    groups_to_add = redmine_groups - google_groups
    groups_to_delete = google_groups - redmine_groups

    unless google_groups.nil?
      for g in groups_to_delete
        directory.delete_group(g)
      end

      for g in groups_to_add
        group = Google::Apis::AdminDirectoryV1::Group.new
        group.email = g
        group.name = EmailGroup.find_by_address(g).name
        directory.insert_group(group)
      end
    end
  end

  def update_members(email_group)
    google_members = list_members(email_group)
    redmine_members = email_group.members.map{ |m| m['mail'] }.sort

    members_to_add = redmine_members - google_members
    members_to_delete = google_members - redmine_members

    unless google_members.nil?
      for m in members_to_delete
        directory.delete_member(email_group.address, m)
      end

      for m in members_to_add
        member = Google::Apis::AdminDirectoryV1::Member.new
        member.email = m
        directory.insert_member(email_group.address, member)
      end
    end
  end

end
