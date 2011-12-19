# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter.link_to').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    data_hash = {}
    finished_hash = {}
    if link_id.length < 19
      data_hash["id"]=link_id
    from = $('input.node_from.link_to.'+link_id).attr("value")
    data_hash['node_from']=from
    value = $(event.target).attr("value")
    if value !='_delete'
      data_hash['value']=value
      to = $('input.node_to.link_to.'+link_id).attr("value")
      data_hash['node_to']=to
    else if data_hash["id"] && value =='_delete'
      data_hash['_delete']=1
    finished_hash={"node":{"link_tos_attributes":[data_hash]}}
    $.ajax   
      url: "/nodes/"+from   
      type: "PUT"   
      data: finished_hash   
      error: (XMLHttpRequest, textStatus, errorThrown) ->     
        alert errorThrown    
      success: (data, textStatus, XMLHttpRequest) ->     
        alert "Succeeded"
    return true
  $('input.submitter.link_in').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    data_hash = {}
    finished_hash = {}
    if link_id.length < 19
      data_hash["id"]=link_id
    to = $('input.node_to.link_in.'+link_id).attr("value")
    data_hash['node_to']=to
    value = $(event.target).attr("value")
    if value !='_delete'
      data_hash['value']=value
      from = $('input.node_from.link_in.'+link_id).attr("value")
      data_hash['node_from']=from
    else if data_hash["id"] && value =='_delete'
      data_hash['_delete']=1
    finished_hash={"node":{"link_ins_attributes":[data_hash]}}
    $.ajax   
      url: "/nodes/"+to   
      type: "PUT"   
      data: finished_hash   
      error: (XMLHttpRequest, textStatus, errorThrown) ->     
        alert errorThrown    
      success: (data, textStatus, XMLHttpRequest) ->     
        alert "Succeeded"
    return true 
  return false
