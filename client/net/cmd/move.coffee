require './handler.coffee'

class CmdMove extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		id = data[1]
		x = data[2]
		y = data[3]
		dx = data[4]
		dy = data[5]

		user = @app.game.users[id]
		return if !user? #error user doesnt exist
		user.x = x
		user.y = y
		user.dx = dx
		user.dy = dy

	validate: (data) ->
		data.length is 6

window.CmdMove = CmdMove