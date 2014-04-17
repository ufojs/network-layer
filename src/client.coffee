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




exports.Client = Client