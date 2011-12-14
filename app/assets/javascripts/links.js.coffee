# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/(^\d+)/)
    inputs = $('[id|="'+link_id+'"]')
    data = inputs.serialize
  return false
