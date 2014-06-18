class WallController < BaseController
  include EmailHelper
  def show
    # discussions that had activity in the last 24 hours


    # TODO UNDO CHANGES TO THIS FILE
    groups = current_user.inbox_groups
    @time_since = 11.days.ago

    @discussions_by_group = Queries::VisibleDiscussions.new(user: current_user,
                                                            groups: groups).
                                                            # unread.
                                                            active_since(@time_since).
                                                            group_by(&:group)

    @user = current_user
    @utm_hash = {}
    render layout: 'fake_email'
  end
end
