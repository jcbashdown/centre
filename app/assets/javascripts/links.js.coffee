# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    $('#link_'+link_id).ajaxLoader()
    data_hash = {}
    data_hash["type"] = $("#link_"+link_id).attr("class")
    if link_id.length < 16
      data_hash["id"] = link_id
    from = $("#"+link_id+"_node_from").attr("value")
    to = $("#"+link_id+"_node_to").attr("value")
    value = $(event.target).attr("value")
    data_hash["link"] = {"node_from_id":from, "value":value, "node_to_id":to}
    if value == "_destroy"
      url = "/links/"+link_id
      method = "DELETE"
    else if link_id >= 16
      url = "/links"
      method = "POST"
    else
      url = "/links/"+link_id
      method = "PUT"
    $.ajax   
      url: url
      type: method  
      data: data_hash   
      dataType: "html"
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        $("#link_"+link_id).ajaxLoaderRemove()
        alert errorThrown    
      success: (data, textStatus, XMLHttpRequest) ->
        $("#link_"+link_id).ajaxLoaderRemove()
        $("#link_"+link_id).replaceWith(data)
    return true
  return false
