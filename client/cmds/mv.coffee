class CmdMv

	constructor: (@user, @game, @sio) ->

		@sio.on 'mv', (id, x, y, dx, dy) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			user.x = x
			user.y = y
			user.dx = dx
			user.dy = dy

window.CmdMv = CmdMv