Component = require '../ef/component'

# info about a connected player
class CPlayerInfo extends Component

	id: 'playerinfo'
	name: null
	room: null

	constructor: (@name) ->


module.exports = CPlayerInfo