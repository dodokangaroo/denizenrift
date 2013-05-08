require './handler.coffee'

class CmdUserJoin extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		if data.length is 2
			u = data[1]

			console.log "User #{u.id} joined"
			@app.game.addUser u

window.CmdUserJoin = CmdUserJoin