Handler = require './handler'
CMD = require '../cmds'

class Register extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->
		@connection.broadcast [CMD.SC.REGISTER_RESULT, true]	

module.exports = Register