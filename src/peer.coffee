{EventEmitter} = require 'events'
{PeeringPacket} = require './peering-packet'
{PeeringReplyPacket} = require './peeringreply-packet'
RTCPeerConnection = window.webkitRTCPeerConnection || window.mozRTCPeerConnection

class Peer extends EventEmitter
  constructor: () ->
    configuration = {
      'iceServers': [
        { 'url': 'stun:stun.l.google.com:19302' },
        { 'url': 'stun:stun.services.mozilla.com' }
      ]
    }
    this.pc = new RTCPeerConnection configuration
    this.dc = null

  generatePeeringPacket: (onPacketReady) ->
    self = this

    packet = new PeeringPacket

    onIceCandidate = (event) ->
      if not event.candidate?
        packet.setOffer self.pc.localDescription
        onPacketReady packet

    onOfferReady = (offer) ->
      self.pc.setLocalDescription offer

    onOfferFail = (error) ->

    onChannelOpened = () ->
      self.emit 'open'

    this.pc.onicecandidate = onIceCandidate
    this.dc = this.pc.createDataChannel 'ufo-channel', null
    this.dc.onopen = onChannelOpened
    this.pc.createOffer onOfferReady, onOfferFail

  setPeeringReply: (peeringReply) ->
    packet = new PeeringReplyPacket peeringReply
    this.pc.setRemoteDescription packet.getAnswer()
    

    

exports.Peer = Peer

