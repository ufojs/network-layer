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

    StubClient = rewire '../src/client'
    StubClient.__set__ 'WebSocket', WebSocket
    StubClient.__set__ 'Peer', MockPeer

    testClient = new StubClient.Client
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

    StubClient = rewire '../src/client'
    StubClient.__set__ 'WebSocket', WebSocket
    StubClient.__set__ 'Peer', MockPeer

    testClient = new StubClient.Client
    testClient.bootstrap 'addr', 'port'


  it 'should set a ws onopen callback', (done) ->
    class WebSocket extends MockWebSocket
      constructor: (address) ->
        self = this
        checkCallback = ->
          self.should.respondTo 'onopen'
          done()

        setTimeout checkCallback, 500

    StubClient = rewire '../src/client'
    StubClient.__set__ 'WebSocket', WebSocket
    StubClient.__set__ 'Peer', MockPeer

    testClient = new StubClient.Client
    testClient.bootstrap 'addr', 'port'

  it 'should create a new peer during bootstrap', (done) ->
    class Peer extends MockPeer
      constructor: () ->
        done()
      generatePeeringPacket: () ->

    StubClient = rewire '../src/client'
    StubClient.__set__ 'Peer', Peer
    StubClient.__set__ 'WebSocket', MockWebSocket

    testClient = new StubClient.Client
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

    StubClient = rewire '../src/client'
    StubClient.__set__ 'WebSocket', MockWebSocket
    StubClient.__set__ 'Peer', Peer

    testClient = new StubClient.Client
    testClient.bootstrap 'addr', 'port'

  it 'should get a peering packet from peer', (done) ->
    MockPeer::generatePeeringPacket = (callback) ->
      MockPeer::generatePeeringPacket = () ->
      callback.should.be.a 'function'
      done()

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should send a peering packet via websocket', (done) ->
    MockPeer::generatePeeringPacket = (callback) ->
      MockPeer::generatePeeringPacket = () ->
      callback 'testPacket'

    MockWebSocket::send = (packet) ->
      MockWebSocket::send = () ->
      packet.should.be.equal 'testPacket'
      done()

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should forward the peering reply to the peer', (done) ->
    MockPeer::setPeeringReply = (packet) ->
      MockPeer::setPeeringReply = () ->
      packet.should.be.equal 'testReplyPacket'
      done()

    MockPeer::generatePeeringPacket = (callback) ->
      MockPeer::generatePeeringPacket = () ->
      callback()

    MockWebSocket::send = (packet) ->
      MockWebSocket::send = () ->
      this.onmessage { data : 'testReplyPacket' }

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should close the websocket after the handshake', (done) ->
    MockPeer::generatePeeringPacket = (callback) ->
      MockPeer::generatePeeringPacket = () ->
      callback()

    MockWebSocket::send = (packet) ->
      MockWebSocket::send = () ->
      this.onmessage { data : 'testReplyPacket' }

    MockWebSocket::close = () ->
      MockWebSocket::close = () ->
      done()

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should push a peer within the pool after connection', (done) ->
    node = null
    id = null

    MockPeer::generatePeeringPacket = (callback) ->
      MockPeer::generatePeeringPacket = (callback) ->
      node = this
      this.id = 'testID'
      id = 'testID'
      this.onopen()

    MockList::add = (id, node) ->
      MockList::add = (id, node) ->
      id.should.be.equal 'testID'
      node.should.be.equal node
      done()

    testClient = new ClientModule.Client
    testClient.bootstrap 'addr', 'port'

  it 'should generate a new peer on densify function called', (done) ->
    class Peer extends MockPeer
      constructor: () ->
        done()

    ClientModule.__set__ 'Peer', Peer

    testClient = new ClientModule.Client
    testClient.densify()

  it 'should select a random peer within the pool', (done) ->
    class List extends MockList
      getNodeList: () ->
        done()

    ClientModule.__set__ 'List', List

    testClient = new ClientModule.Client
    testClient.densify()