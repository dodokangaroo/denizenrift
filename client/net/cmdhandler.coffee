require './cmds.coffee'
require './cmd/move.coffee'
require './cmd/chat.coffee'
require './cmd/setjob.coffee'
require './cmd/userjoin.coffee'
require './cmd/userleft.coffee'
require './cmd/setcmds.coffee'
require './cmd/login.coffee'
require './cmd/joinedgame.coffee'

class CmdHandler

	app: null
	connection: null
	handlers: null
	# this fn can be used to capture an event
	intercept: null

	constructor: (@app, @connection) ->
		@handlers = {}

		@connection.socket.onmessage = @handleMessage

	handleMessage: (msg) =>

		try
			data = JSON.parse msg.data
			id = data[0]
			console.log "< #{id}"
			handler = @handlers[id]
			if handler?
				handler.handle data
			else
				console.log "No handler for #{id}"

			@intercept id, data if @intercept?
		catch error
			console.log "Error: #{error}"
			console.log msg

	setHandlers: (newHandlers) ->
		@handlers = {}
		for name, h of newHandlers
			@handlers[name] = new h @app, @connection

CmdHandler.Factory = 

	startHandlers: ->
		h = {}
		h[CMD.SC.SET_CMDS] = CmdSetCmds
		return h

	mainHandlers: ->
		h = {}
		h[CMD.SC.MOVE] = CmdMove
		h[CMD.SC.CHAT] = CmdChat
		h[CMD.SC.SET_JOB] = CmdSetJob
		h[CMD.SC.USER_JOIN] = CmdUserJoin
		h[CMD.SC.USER_LEFT] = CmdUserLeft
		h[CMD.SC.LOGIN_RESULT] = CmdLogin
		h[CMD.SC.JOINED_GAME] = CmdJoinedGame
		#h[CMD.SC.REGISTER_RESULT] = CmdUserLeft
		return h

window.CmdHandler = CmdHandler