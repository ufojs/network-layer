chai = require 'chai'
expect = chai.expect

{ConnectionPool} = require '../src/connectionPool'

describe 'A generic connection pool', ->

  it 'should be correctly created', ->
    testCP = new ConnectionPool 10
    testCP.size.should.equal 10
    testCP.usedConnections.should.equal 0
    testCP = new ConnectionPool
    testCP.size.should.equal 4

  it 'should add a connection if there is space left', ->
    testCP = new ConnectionPool 1
    testCP.pushConnection 'testConn', 'testName'
    testCP.usedConnections.should.equal 1

  it 'should throw an error if there is no space left', ->
    testCP = new ConnectionPool 1
    testCP.pushConnection 'testConn1', 'testName1'
    testCP.pushConnection.should.throw 'connection pool out of space'

  it 'should get a connection by its name', ->
    testCP = new ConnectionPool 1
    testCP.pushConnection 'testConnection', 'testName'
    testCP.getConnectionByName('testName').should.equal 'testConnection'

  it 'should delete a connection by name', ->
    testCP = new ConnectionPool 1
    testCP.pushConnection 'testConnection', 'testName'
    testCP.deleteConnectionByName 'testName'
    expect(testCP.getConnectionByName 'testName').to.be.undefined
    testCP.usedConnections.should.equal 0

  it 'should tell if a connection exists', ->
    testCP = new ConnectionPool 1
    testCP.pushConnection 'testConnection', 'testName'
    testCP.contains('testName').should.be.true
    testCP.contains('notExisting').should.be.false
