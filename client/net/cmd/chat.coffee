require './handler.coffee'

class CmdChat extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		if data.length is 3
			id = data[1]
			message = data[2]

			user = @app.game.users[id]
			return if !user? #error user doesnt exist
			game.printChat "<div>#{user.data.name}: #{message}</div>"

window.CmdChat = CmdChat