WebSocket = WebSocket if WebSocket?

{List} = require './list'
{Peer} = require './peer'

class Client

  @MAX_CP_SIZE : 5
  @DEN_UPR_BND : 4

  constructor: () ->
    @pool = new List

  bootstrap: (address, port) ->

    self = this
    peer = null

    onPeerConnected = () ->
      self.pool.add peer.id, peer

    onWebSocketMessage = (event) ->
      peer.setPeeringReply event.data
      ws.close()

    onPeeringPacketReady = (packet) ->
      ws.send packet

    onWebSocketOpened = (event) ->
      ws.onmessage = onWebSocketMessage
      peer = new Peer
      peer.onopen = onPeerConnected
      peer.generatePeeringPacket onPeeringPacketReady

    ws = new WebSocket 'ws://' + address + ':' + port
    ws.onopen = onWebSocketOpened

  densify: () ->

    self = this
    peer = null

    onPeeringPacketReady = (packet) ->
      exitNode.send packet

    onPeerConnected = () ->
      self.pool.add peer.id, peer

    exitPoints = @pool.getNodeList()
    exitLabel = exitPoints[Math.floor Math.random() * exitPoints.length]
    exitNode = @pool.getNode exitLabel

    peer = new Peer
    peer.onopen = onPeerConnected
    peer.generatePeeringPacket onPeeringPacketReady


exports.Client = Client