class CmdSetJob

	constructor: (@user, @game, @sio) ->

		@sio.on 'setjob', (id, job) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			user.setJob job			

window.CmdSetJob = CmdSetJob