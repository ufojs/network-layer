class List
  constructor: () ->

  remove: (id) ->
    delete this[id]
    this.onnoderemoved this.getNodeList()

  add: (id, node) ->
    this[id] = node
    this.onnodeadded this.getNodeList()

  getNodeList: () ->
    self = this
    fields = Object.keys this
    isNotAFunction = (element) ->
      return typeof self[element] != 'function'
    return fields.filter(isNotAFunction)

  contains: (nodeId) ->
    return nodeId in this.getNodeList()

  # callbacks section
  onnodeadded: (nodeList) ->
  onnoderemoved: (nodeList) ->

exports.List = List
