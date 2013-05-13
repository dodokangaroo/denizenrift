require './handler.coffee'

class CmdLogin extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		result = data[1]
		user = data[2]

		if result
			@app.loginSuccess user
		else
			@app.loginFailed()

	validate: (data) ->
		data.length is 3

window.CmdLogin = CmdLogin