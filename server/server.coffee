auth = require './auth'
User = require './user'

class Server

	users: []

	constructor: (@server, @io) ->

		@io.on 'connection', (socket) =>

			socket.on 'register', (name, pass, fn) =>
				@register socket, name, pass, fn

			socket.on 'login', (name, pass, fn) =>
				user = @login socket, name, pass, fn

				if user?

					socket.on 'setclass', (heroclass) ->
						user.heroclass = heroclass
						socket.broadcast.emit 'setclass', user.compress()

					socket.on 'mv', (x, y) ->
						user.x = x
						user.y = y
						socket.broadcast.emit 'mv', user.compress()

			socket.server = @

	login: (socket, name, pass, fn) ->
		auth.login name, pass, (res) =>

			fn res

			if res.success
				user = new User socket, name
				@users.push user

				excludes = []

				excludes.push u.compress() for u in @users when u isnt user

				console.log JSON.stringify excludes

				socket.emit 'userlist', excludes
				socket.broadcast.emit 'userjoin', user.compress()

				return user	

	register: (socket, name, pass, fn) ->
		auth.register name, pass, (res) =>
			fn res

module.exports = Server