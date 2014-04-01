class p2pPacket

  constructor: (@type, @body, @isBoozer, @ttl) ->

  addIDToPath: (idToAdd) ->
    @path.push idToAdd

  removeIDFromPath: () ->
    @path.pop()

  toString: () ->
    return JSON.stringify(this)

exports.p2pPacket = p2pPacket