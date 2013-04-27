class CmdChat

	constructor: (@user, @game, @sio) ->

		@sio.on 'chat', (id, message) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			user.console.log(message)

		@sio.on 'chatAll', (message) =>
			return if !@game.user? #error users doesnt exist

			for user in @game.users
				user.console.log(message)

window.CmdChat = CmdChat