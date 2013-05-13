require './handler.coffee'

class CmdUserLeft extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		id = data[1]

		console.log "User #{id} left"
		user = @app.game.users[id]
		return if !user? #error user doesnt exist
		@app.game.entities.splice @app.game.entities.indexOf(user), 1
		@app.game.map.spr.removeChild user.sprContainer
		delete @app.game.users[id]

	validate: (data) ->
		data.length is 2

window.CmdUserLeft = CmdUserLeft