$(document).ready ->

  $('a.delete-question').live "click", (event) ->
    centre.deleteQuestion(this)
