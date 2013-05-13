Component = require '../ef/component'

# info about a connected player
class CPlayerInfo extends Component

	cid: 'playerinfo'

	con: null
	id: null
	name: null
	room: null
	team: null

	constructor: (@con, @name) ->
		@id = @con.id

	serialize: ->
		return {
			id: @id
			name: @name
			room: @room.id
			team: @team
		}

	dump: ->
		console.log """
			PlayerInfo for ##{@id}
			-------------------
			Name: #{@name}
			Room: #{@room.id}
			Team: #{@team}
		"""


module.exports = CPlayerInfo