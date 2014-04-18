chai = require 'chai'
expect = chai.expect

{Client} = require '../src/client'

describe 'A generic client', ->

  it 'should create itself properly', ->
    testClient = new Client
    testClient.pool.should.not.be.null
    expect(testClient.id).to.be.null

    testClient.disconnect.should.not.be.null
    testClient.densify.should.not.be.null
    testClient.bootstrap.should.not.be.null
    testClient.onPeeringRequest.should.not.be.null
    testClient.onBootstrapPerformed.should.not.be.null
    testClient.carryHome.should.not.be.null
