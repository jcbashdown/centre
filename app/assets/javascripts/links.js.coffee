# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter.link_to').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    $('#link_'+link_id).ajaxLoader()
    data_hash = {}
    finished_hash = {}
    if link_id.length < 16
      data_hash["id"]=link_id
    from = $('input.node_from.link_to.'+link_id).attr("value")
    value = $(event.target).attr("value")
    if value !='_destroy'
      data_hash['value']=value
      to = $('input.node_to.link_to.'+link_id).attr("value")
      data_hash['node_to']=to
      data_hash['node_from']=from
    else if data_hash["id"] && value =='_destroy'
      data_hash['_destroy']=1
      to = $('input.node_to.link_to.'+link_id).attr("value")
      data_hash['node_to']=to
      data_hash['node_from']=from
    finished_hash={"node":{"link_tos_attributes":[data_hash]}, "link_id":link_id}
    $.ajax   
      url: "/nodes/"+from+"/add_or_edit_link"  
      type: "PUT"   
      data: finished_hash   
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        $("#link_"+link_id).ajaxLoaderRemove()
        alert errorThrown    
      success: (data, textStatus, XMLHttpRequest) ->
        $("#link_"+link_id).ajaxLoaderRemove()
        $("#link_"+link_id).replaceWith(data)
    return true
  $('input.submitter.link_in').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    $('#link_'+link_id).ajaxLoader()
    data_hash = {}
    finished_hash = {}
    if link_id.length < 16
      data_hash["id"]=link_id
    to = $('input.node_to.link_in.'+link_id).attr("value")
    value = $(event.target).attr("value")
    if value !='_destroy'
      data_hash['value']=value
      from = $('input.node_from.link_in.'+link_id).attr("value")
      data_hash['node_from']=from
      data_hash['node_to']=to
    else if data_hash["id"] && value =='_destroy'
      data_hash['_destroy']=1
      from = $('input.node_from.link_in.'+link_id).attr("value")
      data_hash['node_from']=from
      data_hash['node_to']=to
    finished_hash={"node":{"link_ins_attributes":[data_hash]}, "link_id":link_id}
    $.ajax   
      url: "/nodes/"+to+"/add_or_edit_link"   
      type: "PUT"   
      data: finished_hash   
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        $("#link_"+link_id).ajaxLoaderRemove()
        alert errorThrown    
      success: (data, textStatus, XMLHttpRequest) ->
        $("#link_"+link_id).ajaxLoaderRemove()
        $("#link_"+link_id).replaceWith(data)
    return true 
  return false
