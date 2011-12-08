$(document).ready ->

  $(".load").live 'click', (e) ->
    link = $(e.target).attr('href')
    id = link.match(/(\d+)/)
#    $(".main_content").load link
    $(".right_content").load "/nodes/"+id+"/test" 
    return false
#  $('.submittable').live "click", (event) ->
#    target = $(event.target)
#    inputs
#    hash = {}
#    inputs.each (index) ->
#      value = index.attr('value')
#      alert(value)
#    return
  return false

