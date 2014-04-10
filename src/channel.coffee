WebSocket = Websocket ? null

class channel

  constructor: () ->
    @wrappedChannel = null

  connectViaSocket: (wssAddress, onConnectCallback) ->
    @wrappedChannel = new WebSocket(wssAddress)
    @onConnect = onConnectCallback

  connectViaDatachannel: (datachannel, id) ->

  setSocket: (socket) ->


exports.channel = channel