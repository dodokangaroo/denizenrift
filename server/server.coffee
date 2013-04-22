class Server

	auth = require './auth'
	users: []

	constructor: (@server, @io) ->

		@io.on 'connection', (socket) =>

			socket.on 'register', auth.register
			socket.on 'login', @login
			socket.server = @

	login: (user, pass, fn) ->

		server = @server

		auth.login user, pass, (res) =>

			if res.success
				server.users.push res.user

				for user in server.users
					if user isnt res.user
						console.log user.name

			fn res

module.exports = Server