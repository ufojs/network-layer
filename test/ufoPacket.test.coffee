chai = require 'chai'
chai.should()

{ufoPacket} = require '../src/ufoPacket'

describe 'A generic ufo packet', ->
  it 'should have a constructor', ->
    testPacket = new ufoPacket
    testPacket.should.not.equal null

  it 'should be correctly created with arguments', ->
    testPacket = new ufoPacket 'testType', 'testOrigin', 'testBody', false, 'testTtl'
    testPacket.type.should.equal 'testType'
    testPacket.originator.should.equal 'testOrigin'
    testPacket.body.should.equal 'testBody'
    testPacket.path.length.should.equal 0
    testPacket.isBoozer.should.equal false
    testPacket.ttl.should.equal 'testTtl'

#  it 'should be correctly created without arguments', ->

  it 'should add an id to the path', ->
    testPacket = new ufoPacket 'testType', 'testBody', false
    testPacket.path = []
    testPacket.addIDToPath 'cacca'
    testPacket.addIDToPath 'altracacca'
    testPacket.path[0].should.equal 'cacca'
    testPacket.path.indexOf('altracacca').should.equal 1

  it 'should pop an id from the path', ->
    testPacket = new ufoPacket
    testPacket.path = []
    testPacket.addIDToPath 'cacca'
    testPacket.addIDToPath 'altracacca'
    testPacket.removeIDFromPath()
    testPacket.path.length.should.equal 1
    testPacket.removeIDFromPath()
    testPacket.path.length.should.equal 0

  it 'should convert itself to string', ->
    testPacket = new ufoPacket 'typ', 'org', 'bdy', false, 3
    testPacket.path = ['id']
    texted = testPacket.toString()
    texted.should.equal '{"type":"typ","originator":"org","body":"bdy","isBoozer":false,"ttl":3,"path":["id"]}'

  it 'should generate itself from another string packet', ->
    generator = '{"type":"typ","originator":"org","body":"bdy","isBoozer":true,"ttl":3,"path":["id"]}'
    testPacket = new ufoPacket
    testPacket = testPacket.fromString generator
    testPacket.type.should.equal 'typ'
    testPacket.originator.should.equal 'org'
    testPacket.body.should.equal 'bdy'
    testPacket.isBoozer.should.equal true
    testPacket.ttl.should.equal 3
    testPacket.path[0].should.equal 'id'

  it 'should apply default values when string packet is wrong', ->
    badGenerator = '{"yolo":"cacca"}'
    testPacket = new ufoPacket
    testPacket = testPacket.fromString badGenerator
    testPacket.type.should.equal ''
    testPacket.originator.should.equal ''
    testPacket.body.should.equal ''
    testPacket.isBoozer.should.equal false
    testPacket.ttl.should.equal 0
    testPacket.path.length.should.equal 0

  it 'should convert itself to arraybuffer', ->
    testPacket = new ufoPacket 'typ', 'bdy', true, 0
    testBuffer = testPacket.toArrayBuffer()
    testBuffer.should.not.equal null
    testBuffer[0].should.equal 123
    testBuffer[1].should.equal 34
    testBuffer[59].should.equal 112
