$(document).ready ->
  value = $("#question").val()
  $("#limit_order").change ->
    new_value = $("#question").val()
    if value != new_value && new_value == "#new"
      form = $(this)
      $.get "/globals/new", (data) ->   
        $(form).replaceWith(data)
    else if new_value != "#new"
      $(this).submit()
    return true
  return true
