$ ->
  $("#privacy").tooltip
    placement: "right"

# adds bootstrap popovers to group activity indicators
activate_discussions_tooltips = () ->
  $(".unread-group-activity").tooltip
    placement: "top"
    title: 'There have been new comments on this discussion since you last visited the group.'

$ ->
  is_subgroup = ->
    $('#group_parent_id').val().length > 0

  disable = ($el) ->
    $el.prop('disable', true)
    $el.parent().addClass('disabled')

  check = ($el) ->
    $el.prop('checked', true)

  toggle_discussion_privacy_options = ->
    if is_subgroup()
      if $('#group_visible_to_public').is(':checked')
        $('.group_parent_members_can_see_discussions').hide()
        $('.group_discussion_privacy_options').show()
      else
        $('.group_parent_members_can_see_discussions').show()
        $('.group_discussion_privacy_options').hide()

  set_private_discussions_only = ->
    #check private discussions only
    if !$('#group_visible_to_parent_members').is(':checked')
      check $('#group_parent_members_can_see_discussions_false')
      disable $('#group_parent_members_can_see_discussions_true')


    check $('#group_discussion_privacy_options_private_only')

    #disable other privacy choices
    disable $('#group_discussion_privacy_options_public_or_private,
               #group_discussion_privacy_options_public_only')

  set_public_discussions_only = ->
    #check public discussions only
    check $('#group_discussion_privacy_options_public_only')
    #disable other privacy choices
    disable $('#group_discussion_privacy_options_public_or_private,
               #group_discussion_privacy_options_private_only')

  set_invitation_only = ->
    #check invitation only
    check $('#group_membership_granted_upon_invitation')
    # disable other invitation choices
    disable $('#group_membership_granted_upon_request,
               #group_membership_granted_upon_approval')

  set_members_can_add_members_only = ->
    check $('#group_members_can_add_members_true')
    disable $('#group_members_can_add_members_false')
    $('.group_members_can_add_members').hide()

  update_group_form_state = ->
    return unless $('form.new_group, form.edit_group').length > 0

    #undisable everything
    $('form.new_group input, form.edit_group input').prop('disabled', false)
    $('form.new_group label, form.edit_group label').removeClass('disabled')
    toggle_discussion_privacy_options()
    $('.group_members_can_add_members').show()

    if $('#group_visible_to_public').is(':checked')
      #if anyone can join
      if $('#group_membership_granted_upon_request').is(':checked')
        set_public_discussions_only()
        set_members_can_add_members_only()


    if $('#group_visible_to_parent_members').is(':checked')
      #set_invitation_only()
      set_private_discussions_only()

    if $('#group_visible_to_members').is(':checked')
      set_invitation_only()
      set_private_discussions_only()


  $('form.new_group, form.edit_group').on 'change', ->
    update_group_form_state()

  # and when the dom loads
  update_group_form_state()
