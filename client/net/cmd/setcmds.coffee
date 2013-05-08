require './handler.coffee'

class CmdSetCmds extends Handler

	constructor: (@app, @connection) ->
		super @app, @connection

	handle: (data) ->

		if data.length is 2
			window.CMD = data[1]

			console.log 'Received cmd list'

window.CmdSetCmds = CmdSetCmds