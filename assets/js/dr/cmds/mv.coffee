class CmdMv

	constructor: (@user, @game, @sio) ->

		@sio.on 'mv', (id, x, y) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			user.x = x
			user.y = y

window.CmdMv = CmdMv