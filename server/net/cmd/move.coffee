Handler = require './handler'
CMD = require '../cmds'

class CmdMove extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->
		
		if data.length is 5

			user.x = data[1]
			user.y = data[2]
			user.dx = data[3]
			user.dy = data[4]
			@connection.broadcast [CMD.SC.MOVE, user.id, x, y, dx, dy]

module.exports = CmdMove