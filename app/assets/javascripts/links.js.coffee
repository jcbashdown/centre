# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter.link_to').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    inputs = $('input.link_to.'+link_id)
    data_hash = {}
    inputs.each (index) ->
      reg = new RegExp(link_id+'\[(.*)\]')
      attr = $(this).attr("name")
      attr = attr.match(reg)
      value = $(this).attr("value")[0]
      data_hash[attr]=value
    if link_id.length < 19
      data_hash["id"]=link_id
    end
    finished_hash["node_froms_attributes"]=[data_hash]
    return true
  $('input.submitter.link_in').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    inputs = $('input.link_in.'+link_id)
    return true 
  return false
