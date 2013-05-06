Jobs = require './data/jobs'

class User

	socket: null
	id: 0
	name: null
	x: 0
	y: 0
	dx: 0
	dy: 0
	job: Jobs[0]

	constructor: (@socket, @id, @name) ->

	#remove unwanted vars
	compress: ->
		{
			id: @id
			name: @name
			x: @x
			y: @y
			job: @job?.id
		}


module.exports = User