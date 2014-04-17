{ConnectionPool} = require './connectionPool'
{Peer}           = require './peer'

class Client

  constructor: () ->

    @pool = new ConnectionPool
    @id = null

  disconnect: () ->
    console.log 'disconnect function'

  densify: () ->
    console.log 'densify function'

  bootstrap: () ->
    console.log 'bootstrap function'

  onPeeringRequest: (recPacket, callingPeer) ->
    console.log 'onPeeringRequest function'

  onBootstrapPerformed: () ->
    console.log 'onBootstrapPerformed function'

  carryHome: (message) ->
    console.log 'carryHome function'


exports.Client = Client