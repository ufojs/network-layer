rewire = require 'rewire'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai = require 'chai'
chai.should
expect = chai.expect
chai.use sinonChai

{channel} = require '../src/channel'

describe 'A generic channel', ->

  testChannel = null

  beforeEach ->
    testChannel = new channel

  it 'should be properly created', ->
    testChannel.should.exist
    testChannel.should.have.property 'wrappedChannel'

  it 'should connect to a websocket', (done) ->
    class WebSocket
      constructor: (address) ->
        address.should.be.equal 'websocketAddress'
        done()

    newChannel = rewire '../src/channel'
    newChannel.__set__ 'WebSocket', WebSocket
    testChannel = new newChannel.channel
    testChannel.connectViaSocket('websocketAddress')

  it 'should properly set a callback when connected to a websocket', ->
    class WebSocket

    newChannel = rewire '../src/channel'
    newChannel.__set__ 'WebSocket', WebSocket
    testChannel = new newChannel.channel
    testChannel.connectViaSocket 'wsAddress', 'connectionCallback'
    testChannel.onConnect.should.be.equal 'connectionCallback'