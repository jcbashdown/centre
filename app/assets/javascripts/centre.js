var centre = centre || {};

centre.guid = function() {
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
         s4() + '-' + s4() + s4() + s4();
}

centre.deleteNode = function(context) {
  $.ajax({
    url: $(context).attr("href"),
    type: "DELETE",
    dataType: "json",
    success: function (data) {
      centre.refreshArgument();
      return centre.refreshNodes();
    },
    error: function (xhr, err) {
      return alert("Error");
    }
  });
  return false;
}

centre.deleteQuestion = function(context) {
  $.ajax({
    url: $(context).attr("href"),
    type: "DELETE",
    dataType: "json",
    success: function (data) {
      if($("#question"+data).length > 0){
        $("#question"+data).remove();
      }else{
        window.location.replace(data);
      }
    },
    error: function (xhr, err) {
      return alert("Error");
    }
  });
  return false;
}

centre.createNodeThroughLink = function(context) {
  $.ajax({
    url: $(context).attr("action"),
    type: $(context).attr("method"),
    dataType: "json",
    data: $(context).serialize(),
    success: function (data) {
      var data_hash, query;
      centre.refreshArgument();
      query = $('.nodes_query').attr('value');
      data_hash = {
        "view_configuration": {
          "nodes_query": query
        }
      };
      return centre.hideNodes(data_hash);
    },
    error: function (xhr, err) {
      return alert("Error");
    }
  });
  return false;
}

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
      if ($('#main.argument-builder > .row-fluid > .span12').length > 0){
        $('#main.argument-builder > .row-fluid > .span12').attr('class', 'span8');
      }
      if($('.span4 > #current_nodes').length == 0){
        $('#main.argument-builder > .row-fluid').append("<div class='span4'><div id='current_nodes'></div></div>");
      }
      $('#current_nodes').html(data);
    }
  });
  return false;
}

centre.hideNodes = function() {
  if($('#global_link_context_node_from_title:visible').length == 0 && $('#node_title:visible').length == 0){
    $('#main.argument-builder > .row-fluid > .span8').attr('class', 'span12');
    $('#main.argument-builder > .row-fluid > .span4').remove();
  }
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
