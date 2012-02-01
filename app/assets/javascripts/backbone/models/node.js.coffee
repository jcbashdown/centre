class Centre.Models.Node extends Backbone.Model
  paramRoot: 'node'

  defaults:
    title: null
    text: null

class Centre.Collections.NodesCollection extends Backbone.Collection
  model: Centre.Models.Node
  url: '/nodes'
