class CmdChat

	constructor: (@user, @game, @sio) ->

		@sio.on 'chat', (id, message) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			console.log "#{user.data.name} said: #{message}"

window.CmdChat = CmdChat