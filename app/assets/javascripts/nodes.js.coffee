$(document).ready ->
  $('.typeahead').typeahead(
    source: (typeahead, query) ->
      data_hash = {"view_configuration":{"nodes_query":query}}
      centre.refreshNodes(data_hash)
      url = "/nodes.json"
      method = "GET"
      $.ajax(
        url: url
        type: method  
        data: data_hash   
        error: (XMLHttpRequest, textStatus, errorThrown) ->
          alert errorThrown    
        success: (data, textStatus, XMLHttpRequest) ->
          typeahead.process(data)
      )
    # if we return objects to typeahead.process we must specify the property
    # that typeahead uses to look up the display value
    property: "title"
  )

  $('.icon-minus-sign').live "click", (event) ->
    $(this).hide()
    target_class = $(this).attr('class')
    id_from_class = target_class.replace('icon-minus-sign ', "")
    $('.'+id_from_class).parent().show()
    $('#'+id_from_class).html("")
    $('#'+id_from_class).hide()
    return false 

  $('form.node-edit').live "change", (event) ->
    id = $(this).attr('id')
    $("#"+id).submit()
    return false 
  
  $('a.delete-node').live "click", (event) ->
    $.ajax
      url: $(this).attr("href")
      type: "DELETE" 
      dataType: "json"
      success: (data) ->
        centre.refreshArgument()
        centre.refreshNodes()
      error: (xhr, err) ->
        alert "Error"
    return false 

  $('form.remote-submit-and-refresh').live "submit", (event) ->
    $.ajax
      url: $(this).attr("action")
      type: $(this).attr("method")
      dataType: "json"
      data: $(this).serialize()
      success: (data) ->
        centre.refreshArgument()
        query = $('.nodes_query').attr('value')
        data_hash = {"view_configuration":{"nodes_query":query}}
        centre.hideNodes(data_hash)
      error: (xhr, err) ->
        alert "Error"
    return false 

  #arg builder stuff
  $('.show-new-conclusion').live "click", (event) ->
    centre.refreshNodes()
    $(this).hide()
    $('.hidden.new-conclusion').show()
    $('.hide-new-conclusion').show()
    return false 

  $('.hide-new-conclusion').live "click", (event) ->
    centre.hideNodes()
    $(this).hide()
    $('.hidden.new-conclusion').hide()
    $('.show-new-conclusion').show()
    return false 
    
  $('.show-node-through-link').live "click", (event) ->
    centre.refreshNodes()
    $(this).hide()
    type = $(this).attr('data-type')
    global_node_to_id = $(this).attr('data-global-node-to-id')
    $('.hidden.node-through-link.'+type+'.'+global_node_to_id).show()
    $('.hide-node-through-link[data-type='+type+'][data-global-node-to-id='+global_node_to_id+']').show()
    return false 

  $('.hide-node-through-link').live "click", (event) ->
    centre.hideNodes()
    $(this).hide()
    type = $(this).attr('data-type')
    global_node_to_id = $(this).attr('data-global-node-to-id')
    $('.hidden.node-through-link.'+type+'.'+global_node_to_id).hide()
    $('.show-node-through-link[data-type='+type+'][data-global-node-to-id='+global_node_to_id+']').show()
    return false 

  return false
