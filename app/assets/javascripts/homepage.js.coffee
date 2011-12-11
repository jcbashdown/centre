$(document).ready ->
#  $("#nodes").load "/nodes", ->
#    $(".tabs").tabs()

  $(".tabs").bind 'click', (e) ->
    pattern = /#.+/g
    contentID = e.target.toString().match(pattern)[0]
    $(contentID).load "/" + contentID.replace("#", ""), ->
      $(".tabs").tabs()
  return false
