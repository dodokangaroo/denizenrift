class CmdChat

	constructor: (@user, @server) ->

		user.socket.on 'chat', (message) =>
			user.socket.broadcast.emit 'chat', user.id, message

module.exports = CmdChat