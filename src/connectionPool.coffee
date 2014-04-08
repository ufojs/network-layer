class connectionPool

  constructor: (@size) ->
    @size ?= 4
    @usedConnections = 0

  pushConnection: (connection, connectionName) ->
    if @usedConnections < @size
      this.connectionName = connection
      @usedConnections++
    else
      throw new Error('connection pool out of space')

  getConnectionByName: (connectionName) ->
    return this.connectionName

  deleteConnectionByName: (connectionName) ->
    if this.connectionName
      delete this.connectionName
      @usedConnections--

  exists: (connectionName) ->

exports.connectionPool = connectionPool