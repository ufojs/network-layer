WebSocket = Websocket ? null

class channel

  constructor: () ->
    @wrappedChannel = null

  connectViaSocket: (address, onConnectCallback) ->
    @wrappedChannel = new WebSocket(address)
    @onConnect = onConnectCallback

exports.channel = channel