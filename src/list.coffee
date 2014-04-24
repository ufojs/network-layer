{EventEmitter} = require 'events'

class List extends EventEmitter
  constructor: () ->

  remove: (id) ->
    delete this[id]
    this.emit 'node-removed', this.getNodeList()

  add: (id, node) ->
    this[id] = node
    this.emit 'node-added', this.getNodeList()

  getNodeList: () ->
    self = this
    fields = Object.keys this
    toRemoveIndex = fields.indexOf '_events'
    fields.splice toRemoveIndex, 1
    return fields

  contains: (nodeId) ->
    return nodeId in this.getNodeList()

exports.List = List
