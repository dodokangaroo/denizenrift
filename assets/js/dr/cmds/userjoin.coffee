class CmdUserJoin

	constructor: (@user, @game, @sio) ->

		@sio.on 'userjoin', (u) =>
			@game.addUser u

window.CmdUserJoin = CmdUserJoin