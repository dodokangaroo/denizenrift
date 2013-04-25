class CmdMv

	constructor: (@user, @server) ->

		user.socket.on 'mv', (x, y) =>
			user.x = x
			user.y = y
			user.socket.broadcast.emit 'mv', user.id, x, y

module.exports = CmdMv