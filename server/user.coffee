class User

	socket: null
	id: 0
	name: null
	x: 0
	y: 0
	job: 0

	constructor: (@socket, @id, @name) ->

	#remove unwanted vars
	compress: ->
		{
			id: @id
			name: @name
			x: @x
			y: @y
			job: @job
		}


module.exports = User