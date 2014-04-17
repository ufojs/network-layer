chai = require 'chai'
expect = chai.expect

{Peer} = require '../src/peer'

describe 'A generic peer', ->

  it 'should create itself properly', ->
    testPeer = new Peer
    testPeer.channel.should.not.be.null
    expect(testPeer.peerConnection).to.be.null
    expect(testPeer.remotePort).to.be.null
    testPeer.localPort.should.exist
    testPeer.localPort.should.be.within(5000, 5500)

  it 'should create itself from another peer', ->
    toCopy = new Peer
    toCopy.peerConnection = 'testPeerConnection'
    toCopy.localPort = 5100
    toCopy.remotePort = 5100
    testPeer = new Peer toCopy
    testPeer.peerConnection.should.be.equal 'testPeerConnection'
    testPeer.localPort.should.be.equal 5100
    testPeer.remotePort.should.be.equal 5100