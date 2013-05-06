class CmdMv

	constructor: (@user, @server) ->

		user.socket.on 'mv', (x, y, dx, dy) =>
			user.x = x
			user.y = y
			user.dx = dx
			user.dy = dy
			user.socket.broadcast.emit 'mv', user.id, x, y, dx, dy

module.exports = CmdMv