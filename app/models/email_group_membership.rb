class EmailGroupMembership < ActiveRecord::Base
  belongs_to :email_group

  def members
    list = []

    if include_project_children
      Project.find(include_project_id).children.each do |project|
        case include_role_id
        when nil
        when 0
          Role.all.each do |role|
            unless exclude_role_id == role.id
              role.members.where(project_id: project).map { |m|
                list << { 'user_id' => m.user.id, 'name' => m.user.name, 'mail' => m.user.mail.downcase} unless m.user.nil?
              }
            end
          end
        else
          role = Role.find(include_role_id)
          role.members.where(project_id: project).map { |m|
            list << { 'user_id' => m.user.id, 'name' => m.user.name, 'mail' => m.user.mail.downcase} unless m.user.nil?
          }
        end
      end
    else
      case include_role_id
      when nil
      when 0
        Role.all.each do |role|
          unless exclude_role_id == role.id
            role.members.where(project_id: include_project_id).map { |m|
              list << { 'user_id' => m.user.id, 'name' => m.user.name, 'mail' => m.user.mail.downcase} unless m.user.nil?
            }
          end
        end
      else
        role = Role.find(include_role_id)
        role.members.where(project_id: include_project_id).map { |m|
          list << { 'user_id' => m.user.id, 'name' => m.user.name, 'mail' => m.user.mail.downcase} unless m.user.nil?
        }
      end
    end

    if include_email_group_id.to_i > 0
      list = []
      email_group = EmailGroup.find(include_email_group_id)
      list << { 'user_id' => nil, 'name' => email_group.name, 'mail' => email_group.address.downcase}
    end
    
    return list.uniq
  end

end
