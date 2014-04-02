chai = require 'chai'
chai.should()

{peeringPacket} = require '../src/peeringPacket'

describe 'A generic peering packet', ->
  it 'should have a constructor', ->
    testPacket = new peeringPacket
    testPacket.should.not.equal null

  it 'should be correctly created', ->
    testPacket = new peeringPacket 'testOriginator'
    testPacket.originator.should.equal 'testOriginator'
    testPacket.candidates.should.not.equal null