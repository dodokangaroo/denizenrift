WebSocketServer = require('ws').Server

# rooms
Room = require '../lobby/room'
RoomManager = require '../lobby/roommanager'
# a user connection
Connection = require './connection'
# a user collection
ConnectionManager = require './connectionmanager'
# cmd handler for connection
CmdHandler = require './cmdhandler'
# create specific sets of handlers
CmdFactory = CmdHandler.Factory
# list of cmds
CMD = require './cmds'

class Server

	# a list of all active connections
	connections: null
	# a list of rooms
	rooms: null
	
	constructor: (@webserver) ->

		@connections = new ConnectionManager
		@rooms = new RoomManager

		###
		r = @rooms.create()
		@rooms.add r
		###

		# the ws library can hook onto express servers etc
		@ws = new WebSocketServer server: @webserver

		console.log 'Server started'

		# connect
		@ws.on 'connection', @onConnect

	onConnect: (socket) =>

		# create a new user connection
		c = @connections.create @, socket
		@connections.add c

		console.log "#{new Date()} ##{c.id} connected"

		# send cmd list
		@send c, [CMD.SC.SET_CMDS, CMD]

		# assign initial handlers
		c.handler.setHandlers CmdFactory.login()
		
		# disconnect
		socket.on 'close', =>
			@onDisconnect(c)

	onDisconnect: (c) ->
		
		# remove room
		room = c.e.get('playerinfo')?.room
		room.remove c if room?

		@connections.remove c
		console.log "#{new Date()} ##{c.id} disconnected"

	# send data to a single user
	send: (c, data) ->
		data = JSON.stringify data
		c.socket.send data

	# broadcast to all users and possibly exclude the sender
	broadcast: (data, exclude = null) ->
		data = JSON.stringify data
		for c in @connections
			if c? and !(exclude? and c is exclude)
				c.socket.send data

module.exports = Server