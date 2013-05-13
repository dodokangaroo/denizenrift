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
			pass = data[2]

			# swap login functionality to lobby functionality
			@connection.handler.setHandlers CmdFactory.lobby()

			console.log "#{new Date()} ##{@connection.id} logged in."

			# TODO: load from db etc
			user =
				name: name

			# temp
			info = new CPlayerInfo @connection, name
			@connection.e.add info

			###
			room = @server.rooms.get(0)
			room.add @connection
			###

			@connection.send [CMD.SC.LOGIN_RESULT, true, user]

module.exports = Login