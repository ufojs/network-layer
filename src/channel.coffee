WebSocket = Websocket ? null

class Channel

  constructor: () ->
    @wrappedChannel = null

  on: (eventName, method) ->
    this[eventName] = method

  connectViaSocket: (wssAddress, onConnectCallback) ->
    @wrappedChannel = new WebSocket(wssAddress)
    @onConnect = onConnectCallback
    @setCommChannel this

  connectViaDatachannel: (datachannel, id) ->
    @wrappedChannel = datachannel
    @setCommChannel this, id

  setCommChannel: (commChannel, commID) ->

    @wrappedChannel.onMessage = (message) ->
      console.log 'Message received: ' + message
      message = message.data if message.data?

      message = new p2pPacket.fromString message

      if message.isBoozer = true or message.path.length = 0
        channel[message.type].call channel, message
      else
        # client.carryHome message

    @wrappedChannel.send = (packet) ->
      console.log 'Sending packet: ' + packet
      # packet.addIDToPath client.id if packet.isBoozer
      @wrappedChannel.send packet.toString()


    @wrappedChannel.onClose = 'yolo'
    @wrappedChannel.onError = 'yolo'



exports.Channel = Channel