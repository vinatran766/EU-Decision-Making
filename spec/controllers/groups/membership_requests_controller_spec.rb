require 'spec_helper'

describe Groups::MembershipRequestsController do

  describe '#create' do
    context "invalid membership request" do
      it "renders new"
    end

    context "join membership_granted_upon: request group" do
      it "creates granted membership_request and redirects to group"
    end

    context "join membership_granted_upon: approval group" do
      it "creates membership_request and sets flash notice"
    end

    context "join membership_granted_upon: invitation group" do
      it "redirects to dashboard with 'invitatoin only' message"
    end
  end

  describe '#cancel' do
    let(:requestor) { create(:user) }
    let(:group) { mock_model Group, full_name: "Isolde's Bane" }
    let(:membership_request) { mock_model MembershipRequest, group: group, requestor_id: requestor.id }

    before do
      MembershipRequest.stub(:find).with(membership_request.id.to_s).and_return(membership_request)
      Group.stub(:find).and_return(group)
      membership_request.stub(:destroy)
      controller.stub(:current_user).and_return requestor
      sign_in requestor
    end

    context "a user has permission to cancel membership request" do
      before { controller.stub(:authorize!).with(:cancel, membership_request).and_return(true) }
      it "destroys the membership request" do
        membership_request.should_receive(:destroy)
        post :cancel, id: membership_request.id
      end
      it "redirects them to group page with success flash" do
        post :cancel, id: membership_request.id
        flash[:success].should =~ /Membership request canceled/i
      end
    end

    context "a user doesn't have permission to cancel membership request" do
      before { membership_request.stub(:requestor_id).and_return(requestor.id+1) }
      it "doesn't destroy the membership request" do
        membership_request.should_not_receive(:destroy)
        post :cancel, id: membership_request.id
      end
    end
  end
end
