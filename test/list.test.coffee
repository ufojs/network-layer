# Enabling BDD style
chai = require 'chai'
should = chai.should()
# Test lib
{List} = require '../src/list'

describe 'A peer list', ->

  it 'should exists', (done) ->
    currentList = new List
    currentList.should.not.be.null
    done()

  it 'should register a onnodeadded listener', (done) ->
    currentList = new List
    currentList.should.respondTo 'onnodeadded'
    done()

  it 'should add a new node', (done) ->
    currentList = new List
    currentList.add 'id', 'body'
    currentList['id'].should.be.equal 'body'
    done()

  it 'should pass the current node list when a new node is added', (done) ->
    currentList = new List
    currentList.onnodeadded = (nodeList) ->
      nodeList.should.be.an 'array'
      nodeList.length.should.be.equal 1
      nodeList[0].should.be.equal 'nodeId'
      done()

    currentList.add 'nodeId', 'connection'

  it 'should register a onnoderemoved listener', (done) ->
    currentList = new List
    currentList.should.respondTo 'onnoderemoved'
    done()

  it 'should remove a node', (done) ->
    currentList = new List
    currentList.onnodeadded = (nodeList) ->
      currentList.remove 'id'
      should.not.exist currentList['id']
      done()

    currentList.add 'id', 'body'

  it 'should pass the current node list when a new node is deleted', (done) ->
    currentList = new List

    currentList.onnodeadded = (nodeList) ->
      currentList.remove 'id'

    currentList.onnoderemoved = (nodeList) ->
      nodeList.should.be.an 'array'
      nodeList.length.should.be.equal 0
      done()

    currentList.add 'id', 'node'

  it 'should respond to contains', (done) ->
    currentList = new List
    currentList.should.respondTo 'contains'
    done()

  it 'should reply true if the connection is present', (done) ->
    currentList = new List
    currentList.onnodeadded = (list) ->
      currentList.contains('id').should.be.true
      done()

    currentList.add 'id', 'node'

  it 'should reply false if the connection is not present', (done) ->
    currentList = new List
    currentList.contains('a not id').should.be.false
    done()
