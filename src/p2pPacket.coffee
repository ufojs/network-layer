class p2pPacket

  constructor: (@type, @body, @isBoozer, @ttl) ->
    @path = []

  addIDToPath: (idToAdd) ->
    @path.push idToAdd

  removeIDFromPath: () ->
    @path.pop()

  toString: () ->
    return JSON.stringify(this)

  toBlob: () ->
    return new Blob([JSON.stringify(this)])

  toArrayBuffer: () ->
    texted = JSON.stringify(this)
    buffer = new ArrayBuffer(texted.length)
    bufView = new Int8Array(buffer)
    for i in [0...texted.length]
      bufView[i] = texted.charCodeAt(i)
    return buffer

  fromString: (packet) ->
    packet = JSON.parse(packet)
    @type = packet.type
    @body = packet.body
    @isBoozer = packet.isBoozer
    @ttl = packet.ttl
    @path = packet.path
    return this

exports.p2pPacket = p2pPacket