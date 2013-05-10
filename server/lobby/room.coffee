ConnectionManager = require '../net/connectionmanager'

class Room

	id: null
	users: null
	count: 0
	size: 0

	constructor: (@size) ->
		@users = new ConnectionManager

	add: (c) ->

		info = c.e?.get('playerinfo')

		if info

			info.room.remove c if info.room?

			@users.add c
			info.room = @
			@count++

	remove: (c) ->
		@users.remove c
		c.e?.get('playerinfo')?.room = null
		@count--

	list: ->
		@users.connections

	full: ->
		@count >= @size

	# broadcast to all users in the room and possibly exclude the sender
	broadcast: (data, exclude = null) ->
		data = JSON.stringify data
		for c in @users.connections when c?
			if !(exclude? and c is exclude)
				c.socket.send data

module.exports = Room