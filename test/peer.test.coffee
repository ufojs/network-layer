chai = require 'chai'
should = chai.should()
rewire = require 'rewire'
PeerModule = null
{MockPeerConnection} = require '../lib/ufo-mocks/rtc-peerconnection.mock'
{MockPeeringPacket} = require '../lib/ufo-mocks/peering-packet.mock'
{MockPeeringReplyPacket} = require '../lib/ufo-mocks/peeringreply-packet.mock'

global.window = {}

describe 'A peer', ->

  beforeEach (done) ->
    PeerModule = rewire '../src/peer'
    PeerModule.__set__ 'RTCPeerConnection', MockPeerConnection
    PeerModule.__set__ 'PeeringPacket', MockPeeringPacket
    PeerModule.__set__ 'PeeringReplyPacket', MockPeeringReplyPacket
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
        return this.channel

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection

    thisPeer = new PeerModule.Peer
    thisPeer.generatePeeringPacket () ->

  it 'should emit onopen callback when datachannel connects', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      createOffer: (callback1, callback2) ->
        this.channel.should.respondTo 'onopen'
        this.channel.onopen()

    onOpenCallback = () ->
      done()

    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection
    thisPeer = new PeerModule.Peer
    thisPeer.once 'open', onOpenCallback
    thisPeer.generatePeeringPacket () ->

  it 'should parse peering reply packet', (done) ->
    class CustomPeeringReplyPacket extends MockPeeringReplyPacket
      constructor: (packet) ->
        packet.should.be.equal 'received packet'
        done()

    PeerModule.__set__ 'PeeringReplyPacket', CustomPeeringReplyPacket
    thisPeer = new PeerModule.Peer
    thisPeer.setPeeringReply 'received packet'

  it 'should set peerconnection remote description', (done) ->
    class CustomPeerConnection extends MockPeerConnection
      setRemoteDescription: (descriptor) ->
        descriptor.should.be.equal 'the answer'
        done()
    
    PeerModule.__set__ 'RTCPeerConnection', CustomPeerConnection
    thisPeer = new PeerModule.Peer
    thisPeer.setPeeringReply 'packet'
