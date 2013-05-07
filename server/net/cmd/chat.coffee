Handler = require './handler'
CMD = require '../cmds'

class CmdChat extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->
		if data.length is 2
			msg = data[1]
			# chat log
			console.log "#{new Date()} #{@connection.id} said: #{msg}"
			@connection.broadcast [CMD.SC.CHAT, @connection.id, msg]

module.exports = CmdChat