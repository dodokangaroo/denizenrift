Entity = require '../ef/entity'

class Connection

	id: null
	socket: null
	handler: null
	server: null
	# entity
	e: null

	constructor: (@server, @id, @socket) ->
		@e = new Entity

	send: (data) ->
		@server.send @, data

	broadcast: (data) ->
		@server.broadcast data, @


module.exports = Connection