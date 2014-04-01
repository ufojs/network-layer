chai = require 'chai'
chai.should()

{p2pPacket} = require '../src/p2pPacket'

describe 'A generic p2p packet', ->
  it 'should have a constructor', ->
    testPacket = new p2pPacket
    testPacket.should.not.equal null

  it 'should construct a packet correctly', ->
    testPacket = new p2pPacket 'testType', 'testBody', false, 'testTtl'
    testPacket.type.should.equal 'testType'
    testPacket.body.should.equal 'testBody'
    testPacket.isBoozer.should.equal false
    testPacket.ttl.should.equal 'testTtl'

  it 'should add an id to the path', ->
    testPacket = new p2pPacket 'testType', 'testBody', false
    testPacket.path = []
    testPacket.addIDToPath('cacca')
    testPacket.addIDToPath('altracacca')
    testPacket.path[0].should.equal 'cacca'
    testPacket.path.indexOf('altracacca').should.equal 1

  it 'should pop an id from the path', ->
    testPacket = new p2pPacket
    testPacket.path = []
    testPacket.addIDToPath('cacca')
    testPacket.addIDToPath('altracacca')
    testPacket.removeIDFromPath()
    testPacket.path.length.should.equal 1
    testPacket.removeIDFromPath()
    testPacket.path.length.should.equal 0

  it 'should convert itself to string', ->
    testPacket = new p2pPacket 'typ', 'bdy', 0, 3
    testPacket.path = ['id']
    texted = testPacket.toString()
    texted.should.equal '{"type":"typ","body":"bdy","isBoozer":0,"ttl":3,"path":["id"]}'
