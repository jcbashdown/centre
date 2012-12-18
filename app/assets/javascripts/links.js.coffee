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
    else if link_id.length >= 16
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
        centre.refreshArgument();
        return true
    return true
  return false
