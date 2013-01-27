var centre = centre || {};

centre.refreshNodes = function(view_configuration_data) {
  if (typeof(view_configuration_data)==="undefined") view_configuration_data = {};
  var method, url;
  url = "/nodes.js";
  method = "GET";
  $.ajax({
    url: url,
    type: method,
    data: view_configuration_data,
    dataType: "html",
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      alert(errorThrown);
    },
    success: function(data, textStatus, XMLHttpRequest) {
      if ($('#main > .row-fluid > .span12').length > 0){
        $('#main > .row-fluid > .span12').attr('class', 'span8');
      }
      if($('.span4 > #current_nodes').length == 0){
        $('#main > .row-fluid').append("<div class='span4'><div id='current_nodes'></div></div>");
      }
      $('#current_nodes').html(data);
    }
  });
  return false;
}

centre.hideNodes = function() {
  $('#main > .row-fluid > .span8').attr('class', 'span12');
  $('#main > .row-fluid > .span4').remove();
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
