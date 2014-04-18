rewire = require 'rewire'
sinon = require 'sinon'

{Channel} = require '../src/channel'

describe 'A generic channel', ->

  testChannel = null

  beforeEach ->
    testChannel = new Channel

  it 'should be properly created', ->
    testChannel.should.exist
    testChannel.should.have.property 'wrappedChannel'

  it 'should properly set an event method', ->
    testMethod = 'testMethod'
    testChannel.on 'testEvent', testMethod
    testChannel.testEvent.should.be.equal 'testMethod'

  it 'should connect to a websocket', (done) ->
    class WebSocket
      constructor: (address) ->
        address.should.be.equal 'websocketAddress'
        done()

    newChannel = rewire '../src/channel'
    newChannel.__set__ 'WebSocket', WebSocket
    testChannel = new newChannel.Channel
    testChannel.connectViaSocket 'websocketAddress'

  it 'should properly set a callback when connected to a websocket', ->
    class WebSocket

    newChannel = rewire '../src/channel'
    newChannel.__set__ 'WebSocket', WebSocket
    testChannel = new newChannel.Channel
    testChannel.connectViaSocket 'wsAddress', 'connectionCallback'
    testChannel.onConnect.should.be.equal 'connectionCallback'

  it 'should set every other callback when connected to a websocket ', ->
    class WebSocket

    newChannel = rewire '../src/channel'
    newChannel.__set__ 'WebSocket', WebSocket
    testChannel = new newChannel.Channel
    setupSpy = sinon.spy testChannel, 'setCommChannel'
    testChannel.connectViaSocket 'wsAddress', 'connectionCallback'
    setupSpy.should.be.calledOnce
    testChannel.wrappedChannel.onMessage.should.exist
    testChannel.wrappedChannel.onClose.should.exist
    testChannel.wrappedChannel.onError.should.exist
    testChannel.wrappedChannel.send.should.exist

  it 'should connect to a datachannel', ->
    testChannel.connectViaDatachannel 'testDatachannel', 'testID'
    testChannel.wrappedChannel.should.be.equal 'testDatachannel'
