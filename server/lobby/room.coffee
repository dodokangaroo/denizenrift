ConnectionManager = require '../net/connectionmanager'

class Room

	id: null
	users: null

	constructor: ->
		@users = new ConnectionManager

	add: (c) ->
		@users.add c

	remove: (c) ->
		@users.remove c

	list: ->
		@users.connections

	# broadcast to all users in the room and possibly exclude the sender
	broadcast: (data, exclude = null) ->
		data = JSON.stringify data
		for c in @users.connections
			if c? and !(exclude? and c is exclude)
				c.socket.send data

module.exports = Room