Room = require './room'

class RoomManager

	@UID: 0
	rooms: null
	count: 0

	constructor: ->
		@rooms = []

	create: ->
		r = new Room
		r.id = @getUID()
		return r

	add: (r) ->
		@rooms[r.id] = r
		@count++

	remove: (r) ->
		delete @rooms[r.id]
		@count--

	list: ->
		@rooms

	getUID: ->
		RoomManager.UID++


module.exports = RoomManager