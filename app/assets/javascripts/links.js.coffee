# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter').live "click", (event) ->
    target = $(event.target)
    div = target.parent('div')
    target.submit
  return false
