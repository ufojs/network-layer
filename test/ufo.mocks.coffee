ClientModule = null

class MockList
  constructor: () ->

  add: (id, node) ->

class MockWebSocket
  constructor: () ->
    self = this
    callCallback = () ->
      self.onopen()
    setTimeout callCallback, 50

  onopen: () ->

  onmessage: (event) ->

  send: (packet) ->

  close: () ->

class MockPeer
  generatePeeringPacket: () ->

  setPeeringReply: () ->


exports.MockList = MockList
exports.MockWebSocket = MockWebSocket
exports.MockPeer = MockPeer
