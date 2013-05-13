require './handler.coffee'

class CmdUserJoin extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		u = data[1]

		console.log "User #{u.id} joined"
		#@app.game.addUser u

	validate: (data) ->
		data.length is 2

window.CmdUserJoin = CmdUserJoin