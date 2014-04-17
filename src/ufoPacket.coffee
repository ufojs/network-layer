class UfoPacket

  constructor: (@type, @originator, @body, @isBoozer, @ttl) ->
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
    @type = packet.type ? ''
    @originator = packet.originator ? ''
    @body = packet.body ? ''
    @isBoozer = packet.isBoozer ? false
    @ttl = packet.ttl ? 0
    @path = packet.path ? []
    return this

exports.UfoPacket = UfoPacket