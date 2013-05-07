class Connection

	id: null
	socket: null
	handler: null
	server: null

	constructor: (@server, @id, @socket) ->

	send: (data) ->
		@server.send @, data

	broadcast: (data) ->
		@server.broadcast data, @


module.exports = Connection