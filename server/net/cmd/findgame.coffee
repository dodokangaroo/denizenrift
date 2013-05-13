Handler = require './handler'
CMD = require '../cmds'
CmdFactory = require('../cmdhandler').Factory

class FindGame extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->

		if data.length is 2

			size = data[1]

			console.log "#{new Date()} #{@connection.id} is searching for a game."


			# temp
			info = @connection.e.get('playerinfo')

			# find empty room or create one
			room = @server.rooms.find size
			# make a 5v5 room
			room = @server.rooms.create 10 if !room?

			# add user to room
			room.add @connection

			# change handlers from lobby to game
			#@connection.handler.setHandlers CmdFactory.game()

module.exports = FindGame