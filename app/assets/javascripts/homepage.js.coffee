$(document).ready ->
  value = $("#view_configuration_nodes_question").val()
  $("div.select-form form").live "change", (event) ->
    new_value = $("#view_configuration_nodes_question").val()
    if value != new_value && new_value == "#new"
      $(".select-form").addClass("hidden")
      $(".new-form").removeClass("hidden")
    else if new_value != "#new"
      $(this).submit()
    return true
  return true
