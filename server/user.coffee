class User

	socket: null
	name: null
	x: 0
	y: 0
	heroclass: null

	constructor: (@socket, @name) ->

	#remove unwanted vars
	compress: ->
		{
			name: @name
			x: @x
			y: @y
			heroclass: @heroclass
		}


module.exports = User