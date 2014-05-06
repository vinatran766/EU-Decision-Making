class Groups::MembershipRequestsController < BaseController
  skip_before_filter :authenticate_user!, except: :cancel
  before_filter :build_membership_request

  def new
    store_previous_location
  end

  def create
    service = JoinGroupService.new(@membership_request)
    service.perform!

    if service.membership_granted?
      flash[:notice] = "You have joined #{@group.name}"
      redirect_to @group
    elsif service.membership_pending?
      flash[:success] = t(:'success.membership_requested', which_group: @group.full_name)
      redirect_to after_request_membership_path
    elsif service.membership_denied?
      flash[:notice] = "This group is invitation only"
      redirect_to @group
    end
  end

  def cancel
    @membership_request.destroy
    flash[:success] = t(:'notice.membership_request_canceled')
    redirect_to @membership_request.group
  end

  private

  def build_membership_request
    @group = GroupDecorator.new(Group.find_by_key!(params[:group_id]))
    args = permitted_params.membership_request
    args.merge!(group: @group, requestor: current_user)
    @membership_request = MembershipRequest.new(args)
  end

  def after_request_membership_path
    path = session['user_return_to'] || group_path(@group)
    clear_stored_location
    path
  end
end
