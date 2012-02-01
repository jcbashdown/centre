Centre.Views.Nodes ||= {}

class Centre.Views.Nodes.IndexView extends Backbone.View
  template: JST["backbone/templates/nodes/index"]

  initialize: () ->
    @options.nodes.bind('reset', @addAll)

  addAll: () =>
    @options.nodes.each(@addOne)

  addOne: (node) =>
    view = new Centre.Views.Nodes.NodeView({model : node})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(nodes: @options.nodes.toJSON() ))
    @addAll()

    return this
