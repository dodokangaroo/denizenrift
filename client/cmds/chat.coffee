class CmdChat

	constructor: (@user, @game, @sio) ->

		@sio.on 'chat', (id, message) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			$('.chatout').append "<li>#{user.data.name}: #{message}</li>"
			$('.chatout').animate scrollTop: $('.chatout').prop 'scrollHeight', 200

window.CmdChat = CmdChat