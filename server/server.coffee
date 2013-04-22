auth = require './auth'

class Server

	users: []

	constructor: (@sio) ->


	login: (user, pass, fn) =>
		auth.login user, pass, (res) =>

			if res.success
				@users.push res.user

				for user in users
					if user isnt res.user
						console.log user.name

			fn res

module.exports = Server