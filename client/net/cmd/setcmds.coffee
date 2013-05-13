require './handler.coffee'

class CmdSetCmds extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		window.CMD = data[1]

		console.log 'Received cmd list'

	validate: (data) ->
		data.length is 2

window.CmdSetCmds = CmdSetCmds