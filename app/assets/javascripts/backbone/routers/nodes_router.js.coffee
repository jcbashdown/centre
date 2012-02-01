class Centre.Routers.NodesRouter extends Backbone.Router
  initialize: (options) ->
    @nodes = new Centre.Collections.NodesCollection()
    @nodes.reset options.nodes

  routes:
    "/new"      : "newNode"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newNode: ->
    @view = new Centre.Views.Nodes.NewView(collection: @nodes)
    $("#nodes").html(@view.render().el)

  index: ->
    @view = new Centre.Views.Nodes.IndexView(nodes: @nodes)
    $("#nodes").html(@view.render().el)

  show: (id) ->
    node = @nodes.get(id)

    @view = new Centre.Views.Nodes.ShowView(model: node)
    $("#nodes").html(@view.render().el)

  edit: (id) ->
    node = @nodes.get(id)

    @view = new Centre.Views.Nodes.EditView(model: node)
    $("#nodes").html(@view.render().el)
