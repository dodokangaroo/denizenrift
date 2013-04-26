class CmdSetClass

	constructor: (@user, @game, @sio) ->

		@sio.on 'setclass', (id, heroclass) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			user.setClass heroclass

window.CmdSetClass = CmdSetClass