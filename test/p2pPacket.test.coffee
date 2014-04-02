chai = require 'chai'
chai.should()

{p2pPacket} = require '../src/p2pPacket'

describe 'A generic p2p packet', ->
  it 'should have a constructor', ->
    testPacket = new p2pPacket
    testPacket.should.not.equal null

  it 'should be correctly created', ->
    testPacket = new p2pPacket 'testType', 'testBody', false, 'testTtl'
    testPacket.type.should.equal 'testType'
    testPacket.body.should.equal 'testBody'
    testPacket.path.length.should.equal 0
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
    testPacket = new p2pPacket 'typ', 'bdy', false, 3
    testPacket.path = ['id']
    texted = testPacket.toString()
    texted.should.equal '{"type":"typ","body":"bdy","isBoozer":false,"ttl":3,"path":["id"]}'

  it 'should generate itself from another packet', ->
    generator = '{"type":"typ","body":"bdy","isBoozer":true,"ttl":0,"path":["id"]}'
    testPacket = new p2pPacket
    testPacket = testPacket.fromString(generator)
    testPacket.type.should.equal 'typ'
    testPacket.body.should.equal 'bdy'
    testPacket.isBoozer.should.equal true
    testPacket.ttl.should.equal 0
    testPacket.path[0].should.equal 'id'

  it 'should convert itself to arraybuffer', ->
    testPacket = new p2pPacket 'typ', 'bdy', true, 0
    testBuffer = testPacket.toArrayBuffer()
    testBuffer.should.not.equal null
    testBuffer[0].should.equal 123
    testBuffer[1].should.equal 34
    testBuffer[59].should.equal 93
