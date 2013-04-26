class CmdUserLeft

	constructor: (@user, @game, @sio) ->

		@sio.on 'userleft', (id) =>
			console.log "user #{id} left"
			user = @game.users[id]
			return if !user? #error user doesnt exist
			@game.entities.splice @game.entities.indexOf(user), 1
			delete @game.users[id]

window.CmdUserLeft = CmdUserLeft