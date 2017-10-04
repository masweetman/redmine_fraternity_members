require 'member_role'

module MemberRolePatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      belongs_to :deliverable

      after_create :add_historical_role
      after_destroy :update_historical_role
    end
  end

  module InstanceMethods

  def add_historical_role
    if self.inherited_from.nil? && ![23, 40, 36].include?(self.role_id)
      hr = HistoricalRole.new
      hr.member_role_id = self.id
      hr.member_id = self.member_id
      hr.project_id = Member.find(self.member_id).project_id
      hr.role_id = self.role_id
      hr.user_id = Member.find(self.member_id).user_id
      hr.added_on = Date.today
      hr.save
    end
  end

  def update_historical_role
    if HistoricalRole.where(member_role_id: self.id).any?
      hr = HistoricalRole.where(member_role_id: self.id).first
      hr.removed_on = Date.today
      hr.save
    end
  end

  end
end

MemberRole.send(:include, MemberRolePatch)
