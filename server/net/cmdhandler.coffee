CMD = require './cmds'

class CmdHandler

	server: null
	connection: null
	handlers: null

	constructor: (@server, @connection) ->
		@handlers = {}

		@connection.socket.on 'message', @handleMessage

	handleMessage: (msg) =>

		try
			data = JSON.parse msg
			id = data[0]
			handler = @handlers[id]
			if handler?
				handler.handle data
			else
				console.log "No handler for #{id}"
		catch error
			console.log "Error: #{error}"

	setHandlers: (newHandlers) ->
		@handlers = {}
		for name, h of newHandlers
			@handlers[name] = new h @server, @connection


CmdHandler.Factory =

	login: ->
		h = {}
		h[CMD.CS.LOGIN] = require('./cmd/login')
		h[CMD.CS.REGISTER] = require('./cmd/register')
		return h

	lobby: ->
		h = {}
		h[CMD.CS.FIND_GAME] = require('./cmd/findgame')
		return h

	game: ->
		h = {}
		h[CMD.CS.MOVE] = require('./cmd/move')
		h[CMD.CS.CHAT] = require('./cmd/chat')
		h[CMD.CS.SET_JOB] = require('./cmd/setjob')
		return h

module.exports = CmdHandler