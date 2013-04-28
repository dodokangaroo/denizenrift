class CmdUserJoin

	constructor: (@user, @game, @sio) ->

		@sio.on 'userjoin', (u) =>
			console.log "User #{u.id} joined"
			@game.addUser u

window.CmdUserJoin = CmdUserJoin