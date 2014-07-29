
Scenario: Subscribing and unsubscribing from a group
  When I join a group
  Then I should see that I am subscribed to the group
  And I should have the option to unsubscribe or leave the group

Scenario: Inbox displays new content from groups I am subscribed to
  Given I am subscribed to a group
  Then new content in the group should be in my Inbox

Scenario: Inbox displays new content from discussions I am subscribed to
  Given I am unsubscribed from a group but subscribed to a discussion
  Then new content in the discussion should be in my Inbox

Scenario: Subscribing to a group auto-subscribes me to all new discussions
  Given I am subscribed to a group
  Then I should be subscribed to all new discussions

Scenario: Unsubscribing from a discussion
  Given I am subscribed to a group
  When I unsubscribe from a discussion
  Then new content in the discussion should be in my Inbox

Scenario: Unsubscribing from a group
  Given I am unsubscribed from a group
  Then new content in the group should not be in my Inbox
  But I should still be able to participate in the group as normal

Scenario: Auto-subscribing to discussion
  When I am unsubscribed from a group
  When I participate in a discussion, or someone mentions me
  Then I should be subscribed to that discussion

Scenario: Managing group subscriptions
  Given I am a member of many groups
  When I visit my Email Preferences page
  Then I should be able to configure my subscription status for all my groups in one place
  And I should be able to configure my email preferences for my subscriptions

Scenario: Email settings
  when there is new content in groups that I am subscribed to:
  [-] email it to me immediately, OR
  [-] email me once a day with all the new content, OR
  [-] don't email me, I'll read it in on Loomio

# UI work required
# Group page: join button -> subscribe -> unsubscribe/leave
# Discussion page: subscribe/unsubscribe

