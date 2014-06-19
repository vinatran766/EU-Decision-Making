Given(/^I am a logged out user with an unread discussion$/) do
  @user = FactoryGirl.create(:user)
  @group = FactoryGirl.create(:group)
  @group.add_member!(@user)

  @discussion = FactoryGirl.create(:discussion, group: @group)

  DiscussionReader.for(user: @user, discussion: @discussion).
                   unread_comments_count.should == 1
end

When(/^I mark the email as read$/) do
  visit mark_summary_email_as_read_path(
    email_created_at: 1.hour.from_now,
    unsubscribe_token: @user.unsubscribe_token
  )
end

Then(/^the discussion should be marked as read when the email was generated$/) do
  DiscussionReader.for(user: @user, discussion: @discussion).
                   unread_comments_count.should == 0
end

