WebSocketServer = require('ws').Server

# a user connection
Connection = require './connection'
# cmd handler for connection
CmdHandler = require './cmdhandler'
# create specific sets of handlers
CmdFactory = CmdHandler.Factory

class Server

	# a list of all active connections
	connections: null
	# for generating unique connection ids
	@UID: 0

	constructor: (@webserver) ->

		@connections = []

		# the ws library can hook onto express servers etc
		@ws = new WebSocketServer server: @webserver

		console.log 'Server started'

		# connect
		@ws.on 'connection', (socket) =>

			# assign a unique id
			id = Server.UID++

			console.log "+##{id}"

			# create a new user connection
			c = new Connection @, id, socket

			# store by id for fast lookups
			@connections[id] = c

			# create cmd handler
			c.handler = new CmdHandler @, c

			# assign initial handlers
			c.handler.setHandlers CmdFactory.beforeLogin()
			
			# disconnect
			socket.on 'close', =>
				delete @connections[id]
				console.log "-##{id}"

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