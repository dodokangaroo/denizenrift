Handler = require './handler'
CMD = require '../cmds'
CmdFactory = require('../cmdhandler').Factory

class Login extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->
		# swap login functionality to game functionality
		# TODO: should be lobby functions
		@connection.handler.setHandlers CmdFactory.afterLogin()

		console.log "#{new Date()} #{@connection.id} logged in."

		# TODO: load from db etc
		user = {}

		@connection.send [CMD.SC.LOGIN_RESULT, true, user]		

module.exports = Login