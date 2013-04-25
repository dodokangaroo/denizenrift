class CmdSetClass 

	constructor: (@user, @server) ->

		user.socket.on 'setclass', (heroclass) =>
			user.heroclass = heroclass
			user.socket.broadcast.emit 'setclass', user.id, user.heroclass

module.exports = CmdSetClass