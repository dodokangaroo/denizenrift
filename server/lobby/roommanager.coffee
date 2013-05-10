Room = require './room'

class RoomManager

	@UID: 0
	rooms: null
	count: 0

	constructor: ->
		@rooms = []

	create: (size) ->
		r = new Room size
		r.id = @getUID()
		@add r
		return r

	add: (r) ->
		@rooms[r.id] = r
		@count++

	remove: (r) ->
		delete @rooms[r.id]
		@count--

	get: (id) ->
		@rooms[id]

	list: ->
		@rooms

	find: (size) ->
		for r in @rooms when r?
			if r.size is size and !r.full()
				return r

	getUID: ->
		RoomManager.UID++


module.exports = RoomManager