$(document).ready ->

  $(".load_new").live 'click', (e) ->
    $(".main_content").load "/nodes/new"
    return false
  return false

