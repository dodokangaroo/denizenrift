class CmdChat

	constructor: (@user, @game, @sio) ->

		@sio.on 'chat', (id, message) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			game.printChat "<div>#{user.data.name}: #{message}</div>"

window.CmdChat = CmdChat