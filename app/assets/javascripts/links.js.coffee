# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('input.submitter').live "click", (event) ->
    target_id = $(event.target).attr('id')
    link_id = target_id.match(/^\d+/)[0]
    $('#link_'+link_id).ajaxLoader()
    data_hash = {}
    data_hash["direction"] = $("#link_"+link_id).attr("class")
    if link_id.length < 16
      data_hash["id"] = link_id
    from = $("#"+link_id+"_node_from").attr("value")
    to = $("#"+link_id+"_node_to").attr("value")
    data_hash["type"] = $(event.target).attr("value")
    data_hash["global_link"] = {"global_node_from_id":from, "global_node_to_id":to}
    if data_hash["type"] == "_destroy"
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
        visible = $("li.arg-option.active > a")
        path = visible.attr("href")
        active_panel = visible.attr("data-target")
        $.ajax   
          url: path
          type: "get"
          dataType: "html"
          success: (data, textStatus, XMLHttpRequest) ->
            $(active_panel).html(data)
            return false
          # not working as within js - either eval returned js or replace data target with html and request html - either way, need success
        return true
    return true
  return false
