require './handler.coffee'

class CmdChat extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		id = data[1]
		message = data[2]

		user = @app.game.users[id]
		return if !user? #error user doesnt exist
		game.printChat "<div>#{user.data.name}: #{message}</div>"

	validate: (data) ->
		data.length is 3

window.CmdChat = CmdChat