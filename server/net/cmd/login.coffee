Handler = require './handler'
CMD = require '../cmds'
CmdFactory = require('../cmdhandler').Factory

CPlayerInfo = require '../../components/cplayerinfo'

class Login extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->

		if data.length is 3

			name = data[1]

			# swap login functionality to game functionality
			# TODO: should be lobby functions
			@connection.handler.setHandlers CmdFactory.afterLogin()

			console.log "#{new Date()} #{@connection.id} logged in."

			# TODO: load from db etc
			user = {}

			# temp
			room = @server.rooms.get(0)

			info = new CPlayerInfo name
			@connection.e.add info

			room.add @connection

			@connection.send [CMD.SC.LOGIN_RESULT, true, user]

module.exports = Login