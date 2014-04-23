chai = require 'chai'
rewire = require 'rewire'
chai.should()
{MockPeer} = require '../lib/ufo-mocks/peer.mock'
{MockWebSocket} = require '../lib/ufo-mocks/websocket.mock'
{MockList} = require '../lib/ufo-mocks/list.mock'

ClientModule = null

describe 'A generic client', ->

  beforeEach ->
    ClientModule = rewire '../src/client'
    ClientModule.__set__ 'WebSocket', MockWebSocket
    ClientModule.__set__ 'Peer', MockPeer
    ClientModule.__set__ 'List', MockList

  it 'should properly define constants', ->
    ClientModule.Client.MAX_CP_SIZE.should.be.equal 5
    ClientModule.Client.DEN_UPR_BND.should.be.equal 4

  it 'should create an empty pool after construction', ->
    testClient = new ClientModule.Client
    testClient.pool.should.exist

  it 'should have a bootstrap function', ->
    testClient = new ClientModule.Client
    testClient.should.respondTo 'bootstrap'

  it 'should have a densify function', ->
    testClient = new ClientModule.Client
    testClient.should.respondTo 'densify'

  it 'should connect to a websocket', (done) ->
    class WebSocket extends MockWebSocket
      constructor: (address) ->
        address.should.be.equal 'ws://testaddress:5000'
        done()

    ClientModule.__set__ 'WebSocket', WebSocket
    ClientModule.__set__ 'Peer', MockPeer

    testClient = new ClientModule.Client
    testClient.bootstrap 'testaddress', 5000

  it 'should set a ws onmessage callback', (done) ->
    class WebSocket extends MockWebSocket
      constructor: (address) ->
        self = this
        checkCallback = ->
          self.should.respondTo 'onmessage'
          done()
        callOnopen = ->
          self.onopen()
          setTimeout checkCallback, 100

        setTimeout callOnopen, 100

    ClientModule.__set__ 'WebSocket', WebSocket
    ClientModule.__set__ 'Peer', MockPeer

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'


  it 'should set a ws onopen callback', (done) ->
    class WebSocket extends MockWebSocket
      constructor: (address) ->
        self = this
        checkCallback = ->
          self.should.respondTo 'onopen'
          done()

        setTimeout checkCallback, 500

    ClientModule.__set__ 'WebSocket', WebSocket
    ClientModule.__set__ 'Peer', MockPeer

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should create a new peer during bootstrap', (done) ->
    class Peer extends MockPeer
      constructor: () ->
        done()
      generatePeeringPacket: () ->

    ClientModule.__set__ 'Peer', Peer
    ClientModule.__set__ 'WebSocket', MockWebSocket

    testClient = new ClientModule.Client
    testClient.bootstrap 'testaddress', 5000

  it 'should set a peer onopen callback', (done) ->
    class Peer extends MockPeer
      constructor: () ->
        self = this
        checkCallback = ->
          self.should.respondTo 'onopen'
          done()

        setTimeout checkCallback, 1000

      generatePeeringPacket: () ->

    ClientModule.__set__ 'WebSocket', MockWebSocket
    ClientModule.__set__ 'Peer', Peer

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should get a peering packet from peer', (done) ->
    class Peer extends MockPeer
      generatePeeringPacket: (callback) ->
        callback.should.be.a 'function'
        done()

    ClientModule.__set__ 'Peer', Peer

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should send a peering packet via websocket', (done) ->
    class Peer extends MockPeer
      generatePeeringPacket: (callback) ->
        callback 'testPacket'

    class WebSocket extends MockWebSocket
      send: (packet) ->
        packet.should.be.equal 'testPacket'
        done()

    ClientModule.__set__ 'Peer', Peer
    ClientModule.__set__ 'WebSocket', WebSocket

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should forward the peering reply to the peer', (done) ->
    class Peer extends MockPeer
      setPeeringReply: (packet) ->
        packet.should.be.equal 'testReplyPacket'
        done()
      generatePeeringPacket: (callback) ->
        callback()

    class WebSocket extends MockWebSocket
      send: (packet) ->
        this.onmessage { data : 'testReplyPacket' }

    ClientModule.__set__ 'Peer', Peer
    ClientModule.__set__ 'WebSocket', WebSocket

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should close the websocket after the handshake', (done) ->
    class Peer extends MockPeer
      generatePeeringPacket: (callback) ->
        callback()

    class WebSocket extends MockWebSocket
      send: (packet) ->
        this.onmessage { data : 'testReplyPacket' }
      close: () ->
        done()

    ClientModule.__set__ 'Peer', Peer
    ClientModule.__set__ 'WebSocket', WebSocket

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should push a peer within the pool after connection', (done) ->
    node = null
    id = null

    class Peer extends MockPeer
      generatePeeringPacket: (callback) ->
        node = this
        this.id = 'testID'
        id = 'testID'
        this.onopen()

    class List extends MockList
      add: (id, node) ->
        id.should.be.equal 'testID'
        node.should.be.equal node
        done()

    ClientModule.__set__ 'Peer', Peer
    ClientModule.__set__ 'List', List

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should generate a new peer on densify function called', (done) ->
    class Peer extends MockPeer
      constructor: () ->
        done()

    ClientModule.__set__ 'Peer', Peer

    testClient = new ClientModule.Client
    testClient.densify()

  it 'should get node list on densification called', (done) ->
    class List extends MockList
      getNodeList: () ->
        done()
        return [ ]

    ClientModule.__set__ 'List', List

    testClient = new ClientModule.Client
    testClient.densify()

  it 'should select a random peer within its pool on densify', (done) ->
    originalMath = Math.random
    originalFloor = Math.floor

    class List extends MockList
      getNodeList: () ->
        return [ 'testPeer1', 'testPeer2' ]
      getNode: (id) ->
        id.should.be.equal 'testPeer2'
        global.Math.random = originalMath
        global.Math.floor = originalFloor
        done()

    global.Math.random = () ->
      return 0.6

    global.Math.floor = (number) ->
      number.should.be.equal 1.2
      return 1

    ClientModule.__set__ 'List', List

    testClient = new ClientModule.Client
    testClient.densify()