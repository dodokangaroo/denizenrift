require './handler.coffee'

class CmdSetJob extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		id = data[1]
		job = data[2]

		user = @app.game.users[id]
		return if !user? #error user doesnt exist
		user.setJob job

	validate: (data) ->
		data.length is 3	

window.CmdSetJob = CmdSetJob