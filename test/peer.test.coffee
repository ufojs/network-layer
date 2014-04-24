chai = require 'chai'
should = chai.should()
rewire = require 'rewire'
PeerModule = null
{MockPeerConnection} = require '../lib/ufo-mocks/rtc-peerconnection.mock'
{MockPeeringPacket} = require '../lib/ufo-mocks/peering-packet.mock'

global.window = {}

describe 'A peer', ->

  beforeEach (done) ->
    PeerModule = rewire '../src/peer'
    PeerModule.__set__ 'RTCPeerConnection', MockPeerConnection
    PeerModule.__set__ 'PeeringPacket', MockPeeringPacket
    done()

  it 'should keep a peerconnection instance', (done) ->
    thisPeer = new PeerModule.Peer
    should.exist thisPeer.pc
    done()

  it 'should call createOffer', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      createOffer: (onOfferReady, onOfferFail) ->
        onOfferReady.should.be.a 'function'
        onOfferReady.should.be.a 'function'
        done()

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection
    
    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket () ->

  it 'should set local descriptor', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      setLocalDescription: (descriptor) ->
        descriptor.sdp.should.be.equal 'sdp'
        descriptor.type.should.be.equal 'offer'
        done()

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection
    
    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket () ->

  it 'should wait for the end of candidates', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      localDescription: 'without candidates'
      
      setLocalDescription: (descriptor) ->
        self = this

        addCandidates = () ->
          self.localDescription = 'with candidates'
          self.onicecandidate {}

        this.should.respondTo 'onicecandidate'
        this.onicecandidate { 'candidate': 'a candidate' }
        setTimeout addCandidates, 50

    class CustomPeeringPacket extends MockPeeringPacket
      setOffer: (offer) ->
        offer.should.be.equal 'with candidates'
        done()

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection
    PeerModule.__set__ 'PeeringPacket', CustomPeeringPacket
    
    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket () ->


  it 'should generate a peering packet', (done) ->
    class CustomPeeringPacket extends MockPeeringPacket
      constructor: () ->
        done()

    PeerModule.__set__ 'PeeringPacket', CustomPeeringPacket
    
    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket () ->

  it 'should call onPacketReady callback', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      localDescription: 'offer'
      setLocalDescription: (offer) ->
        this.onicecandidate {}

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection

    callback = (packet) ->
      packet.offer.should.be.equal 'offer'
      done()

    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket callback

  it 'should create a data channel', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      createDataChannel: (label, opts) ->
        label.should.be.equal 'ufo-channel'
        should.not.exist opts
        done()

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection

    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket () ->
