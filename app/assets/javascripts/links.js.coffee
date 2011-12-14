# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter.link_to').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    inputs = $('input.link_to.'+link_id)
    return true
  $('input.submitter.link_in').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    inputs = $('input.link_in.'+link_id)
    return true 
  return false
