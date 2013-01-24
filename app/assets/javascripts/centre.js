var centre = (centre) ? centre : {};

centre.refreshNodes = function(view_configuration_data = {}) {
  var method, url;
  url = "/nodes.js";
  method = "GET";
  $.ajax({
    url: url,
    type: method,
    data: view_configuration_data,
    dataType: "html",
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      return alert(errorThrown);
    },
    success: function(data, textStatus, XMLHttpRequest) {
      return $('#current_nodes').html(data);
    }
  });
  return false;
}

centre.refreshArgument = function() {
  var argument, user_id;
  var active_argument = $('.tab-pane.active').attr("id");

  if (active_argument === "everyones_topic") {
    $.get("/question_arguments", {
      path: "everyones_topic"
    }, function(data) {
      argument = data;
      return false;
    });
  } else if (active_argument === "other_user_topic") {
    user_id = $(".user_argument").attr("id");
    $.get("/user_arguments", {
      user_id: user_id,
      path: "other_user_topic"
    }, function(data) {
      argument = data;
      return false;
    });
  } else {
    $.get("/user_arguments", {
      user_id: "<%= current_user.id %>",
      path: "my_topic"
    }, function(data) {
      argument = data;
      return false;
    });
  }
  $("#" + active_argument).html(argument);
  return false;
}
