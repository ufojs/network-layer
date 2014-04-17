{Channel}   = require './channel'
{UfoPacket} = require './ufoPacket'

class Peer

  constructor: (other) ->

    @channel = new Channel


    if other?
      @peerConnection = other.peerConnection
      @localPort = other.localPort
      @remotePort = other.remotePort
    else
      @peerConnection = null
      @localPort = Math.round(Math.random() * (500)) + 5000
      @remotePort = null

exports.Peer = Peer