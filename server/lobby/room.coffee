ConnectionManager = require '../net/connectionmanager'
CMD = require '../net/cmds'

class Room

	# room id
	id: null

	# list of users
	users: null

	# num of users
	count: 0

	# max users
	size: 0

	# list of teams
	teams: [0, 1]

	constructor: (@size) ->
		@users = new ConnectionManager

	add: (c) ->

		info = c.e?.get('playerinfo')

		if info

			info.room.remove c if info.room?

			@users.add c
			info.room = @
			@count++

			info.team = @smallestTeam()

			@publishJoin c

	remove: (c) ->
		@users.remove c
		c.e?.get('playerinfo')?.room = null
		@count--
		@publishLeave c

	list: ->
		@users.connections

	full: ->
		@count >= @size

	usersForTeam: (team) ->
		list = []
		for u in @users.connections when u?
			info = u.e?.get('playerinfo')
			if info?.team is team
				list.push u
		return list

	teamLength: (team) ->
		@usersForTeam(team).length

	smallestTeam: ->
		shortest = 99999
		team = -1
		for t in @teams
			l = @teamLength t
			if l < shortest
				team = t
				shortest = l
		return team

	# notify about a join
	publishJoin: (con) ->

		cinfo = con.e?.get('playerinfo')

		data = []

		for c in @users.connections when c? and c isnt con
			info = c.e?.get('playerinfo')
			data.push info.serialize()

		@broadcast [CMD.SC.USER_JOIN, cinfo.serialize()], con
		con.send [CMD.SC.JOINED_GAME, @id, cinfo.team, data]

	publishLeave: (con) ->
		@broadcast [CMD.SC.USER_LEFT, con.id]

	# broadcast to all users in the room and possibly exclude the sender
	broadcast: (data, exclude = null) ->
		for c in @users.connections when c?
			if !(exclude? and c is exclude)
				c.send data

module.exports = Room