Component = require '../ef/component'

# info about a connected player
class CPlayerInfo extends Component

	id: 'cplayerinfo'
	name: null

	constructor: ->

CPlayerInfo.Factory = 

	login: (socket, name, pass) ->
		# do something

module.exports = CPlayerInfo