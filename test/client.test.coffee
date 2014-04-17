chai = require 'chai'
should = chai.should()
expect = chai.expect

{Client} = require '../src/client'

describe 'A generic client', ->

  it 'should create itself properly', ->
    testClient = new Client
    testClient.pool.should.not.be.null
    expect(testClient.id).to.be.null
