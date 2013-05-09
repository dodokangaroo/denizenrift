Connection = require './connection'
CmdHandler = require './cmdhandler'

class ConnectionManager

	@UID: 0
	connections: null
	count: 0

	constructor: ->
		@connections = []

	create: (server, socket) ->
		# unique connection id
		id = @getUID()
		# create new connection
		c = new Connection server, id, socket
		# create cmd handler
		c.handler = new CmdHandler server, c

		return c

	add: (c) ->
		@connections[c.id] = c
		@count++

	remove: (c) ->
		delete @connections[c.id]
		@count--

	list: ->
		@connections

	getUID: ->
		ConnectionManager.UID++

	findByName: (name) ->
		for c in @connections when c?
			# slightly long...
			cname = c.e.get('playerinfo')?.name
			if cname is name then return c

module.exports = ConnectionManager