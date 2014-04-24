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

  it 'should add a new node', (done) ->
    currentList = new List
    currentList.add 'id', 'body'
    currentList['id'].should.be.equal 'body'
    done()

  it 'should pass the current node list when a new node is added', (done) ->
    currentList = new List
    onNodeAdded = (nodeList) ->
      nodeList.should.be.an 'array'
      nodeList.length.should.be.equal 1
      nodeList[0].should.be.equal 'nodeId'
      done()

    currentList.on 'node-added', onNodeAdded
    currentList.add 'nodeId', 'connection'

  it 'should remove a node', (done) ->
    currentList = new List
    onNodeAdded = (nodeList) ->
      currentList.remove 'id'
      should.not.exist currentList['id']
      done()

    currentList.on 'node-added', onNodeAdded
    currentList.add 'id', 'body'

  it 'should pass the current node list when a new node is deleted', (done) ->
    currentList = new List

    onNodeAdded = (nodeList) ->
      currentList.remove 'id'

    onNodeRemoved = (nodeList) ->
      console.log nodeList
      nodeList.should.be.an 'array'
      nodeList.length.should.be.equal 0
      done()

    currentList.on 'node-added', onNodeAdded
    currentList.on 'node-removed', onNodeRemoved
    currentList.add 'id', 'node'

  it 'should respond to contains', (done) ->
    currentList = new List
    currentList.should.respondTo 'contains'
    done()

  it 'should reply true if the connection is present', (done) ->
    currentList = new List
    onNodeAdded = (list) ->
      currentList.contains('id').should.be.true
      done()

    currentList.on 'node-added', onNodeAdded
    currentList.add 'id', 'node'

  it 'should reply false if the connection is not present', (done) ->
    currentList = new List
    currentList.contains('a not id').should.be.false
    done()
