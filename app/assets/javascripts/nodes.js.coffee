$(document).ready ->

  $(".load").live 'click', (e) ->
    link = $(e.target).attr('href')
    $(".main_content").load link
    return false
  return false

