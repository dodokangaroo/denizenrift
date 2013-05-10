require './handler.coffee'

class CmdJoinedGame extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		if data.length is 3
			roomid = data[1]
			users = data[2]

			@app.joinedRoom roomid, users

window.CmdJoinedGame = CmdJoinedGame