auth = require './auth'
User = require './user'

class Server

	users: null
	uniqueID: 0

	#all cmds client sends to server
	cmds: [
		require('./cmds/mv'),
		require('./cmds/chat'),
		require('./cmds/setjob')
	]

	constructor: (@express, @io) ->

		@users = []

		console.log 'Server started'

		@io.on 'connection', (socket) =>

			id = @uniqueID++

			console.log "User #{id} joined."

			socket.on 'register', (name, pass, fn) =>
				@register socket, name, pass, fn

			socket.on 'login', (name, pass, fn) =>
				user = @login socket, id, name, pass, fn

				if user?
					for cmd in @cmds
						new cmd user, @

			socket.on 'disconnect', =>
				socket.broadcast.emit 'userleft', id
				delete @users[id] if @users[id]?
				console.log "User #{id} left."

			socket.express = @

	login: (socket, id, name, pass, fn) ->
		auth.login name, pass, (res) =>

			fn res

			if res.success
				user = new User socket, id, name
				@users[user.id] = user

				excludes = []

				excludes.push u.compress() for u in @users when u isnt user and u?

				socket.emit 'userlist', excludes
				socket.broadcast.emit 'userjoin', user.compress()

				return user	

	register: (socket, name, pass, fn) ->
		auth.register name, pass, (res) =>
			fn res

module.exports = Server

