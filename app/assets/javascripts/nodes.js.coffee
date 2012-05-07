$(document).ready ->
  question = $('#global_id').text()
  $('.typeahead').typeahead(
    source: (typeahead, query) ->
      url = "/nodes.js"
      method = "GET"
      data_hash = {"find":query, "question":question}
      $.ajax(
        url: url
        type: method  
        data: data_hash   
        dataType: "html"
        error: (XMLHttpRequest, textStatus, errorThrown) ->
          alert errorThrown    
        success: (data, textStatus, XMLHttpRequest) ->
          $('#current_nodes').html(data)
          url = "/nodes.json"
          method = "GET"
          data_hash = {"find":query, "question":question}
          $.ajax(
            url: url
            type: method  
            data: data_hash   
            error: (XMLHttpRequest, textStatus, errorThrown) ->
              alert errorThrown    
            success: (data, textStatus, XMLHttpRequest) ->
              typeahead.process(data)
          )
      )
    # if we return objects to typeahead.process we must specify the property
    # that typeahead uses to look up the display value
    property: "title"
  )
