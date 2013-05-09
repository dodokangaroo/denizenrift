module.exports = (express, server) ->

	express.get '/debug/rooms', (req, res) =>
		s = "<h1>Rooms</h1>"
		s += "<table>"
		s += "<tr><th>ID</th><th>Users</td></tr>"
		for room in server.rooms.list()
			s += """
				 <tr>
				 	<td>#{room?.id}</td>
				 	<td>#{room?.count}</td>
				 </tr>
				 """
		s += "</table>"
		res.end s

	express.get '/debug/users', (req, res) =>
		s = "<h1>Users</h1>"
		s += "<table>"
		s += "<tr><th>ID</th><th>Name</td></tr>"
		for con in server.connections.list() when con?
			s += """
				 <tr>
				 	<td>#{con.id}</td>
				 	<td>#{con.e.get('playerinfo')?.name}</td>
				 </tr>
				 """
		s += "</table>"
		res.end s