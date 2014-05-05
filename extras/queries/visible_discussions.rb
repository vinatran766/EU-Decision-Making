class Queries::VisibleDiscussions < Delegator
  def initialize(user: nil, groups: nil, group_ids: nil)
    @user = user

    if groups.present?
      group_ids = Array(groups).map(&:id)
    end

    @relation = Discussion.joins(:group).merge(Group.published).published

    if @user.present?
      @relation = @relation.joins("LEFT OUTER JOIN discussion_readers dv ON dv.discussion_id = discussions.id AND dv.user_id = #{@user.id}")
    end

    @relation = self.class.apply_privacy_sql(user: @user, group_ids: group_ids, relation: @relation)

    super(@relation)
  end

  def __getobj__
    @relation
  end

  def __setobj__(obj)
    @relation = obj
  end

  def unread
    @relation = @relation.where('(dv.last_read_at < discussions.last_comment_at) OR dv.last_read_at IS NULL')
    self
  end

  def self.apply_privacy_sql(user: nil, group_ids: [], relation: nil)
    if user.present? && group_ids.present?
      relation.where("-- group_id is in requested group_ids
                      group_id IN (:group_ids) AND
                      -- the discussion is public
                      ((discussions.private = FALSE AND groups.discussion_privacy_options != 'private_only') OR
                      -- or they are a member of the group
                       (group_id IN (:user_group_ids)) OR
                      -- or user belongs to parent group and permission is inherited
                      (groups.parent_members_can_see_discussions = TRUE AND groups.parent_id IN (:user_group_ids)))",
                      group_ids: group_ids,
                      user_group_ids: user.cached_group_ids)
    elsif user.present? && group_ids.blank?
      relation.where('group_id IN (:user_group_ids)', user_group_ids: user.cached_group_ids)
    elsif user.blank? && group_ids.present?
      relation.where("group_id IN (:group_ids) AND discussions.private = FALSE AND groups.discussion_privacy_options != 'private_only'",
                                  group_ids: group_ids)
    else
      []
    end

  end

end
