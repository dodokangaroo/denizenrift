class CmdSetClass

	constructor: (@user, @game, @sio) ->

		@sio.on 'setclass', (id, heroclass) =>
			user = @game.users[id]
			return if !user? #error user doesnt exist
			user.setClass heroclass
			user.heroclass.Health += user.heroclass.Str * 10
			user.heroclass.Mana += user.heroclass.Int * 13				

window.CmdSetClass = CmdSetClass