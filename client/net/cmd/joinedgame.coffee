require './handler.coffee'

class CmdJoinedGame extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		roomid = data[1]
		team = data[2]
		users = data[3]

		console.log JSON.stringify users

		@app.joinedRoom roomid, users

	validate: (data) ->
		data.length is 4

window.CmdJoinedGame = CmdJoinedGame