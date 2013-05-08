class Connection

	socket: null
	handler: null

	connect: (url, fn, disconnectfn) ->
		@socket = new WebSocket url
		@socket.onopen = =>
			fn() if fn?
		@socket.onclose = =>
			disconnectfn() if disconnectfn?

	send: (data) ->
		@socket.send JSON.stringify data

window.Connection = Connection