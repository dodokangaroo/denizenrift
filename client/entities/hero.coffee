require '../data/config.coffee'
require '../utils/input.coffee'

class Hero

	speed: 2

	# is this the local user
	userControlled: false

	# sprite
	spr: null

	# player info
	data: null

	constructor: (@game, @heroclass) ->
		@setClass @heroclass

	setClass: (@heroclass) =>

		# remove old graphic
		@game.stage.removeChild @spr if @spr?

		#get new graphic
		@spr = new PIXI.MovieClip [
			PIXI.Texture.fromFrame "Hero #{@heroclass} 0.png"
			PIXI.Texture.fromFrame "Hero #{@heroclass} 1.png"
			PIXI.Texture.fromFrame "Hero #{@heroclass} 2.png"
			PIXI.Texture.fromFrame "Hero #{@heroclass} 3.png"
		]

		# add graphic
		@game.stage.addChild @spr

	update: =>

		# if player controlled
		if @userControlled
			dx = 0
			dy = 0

			dy -= @speed if Input.keys[Key.W]
			dy += @speed if Input.keys[Key.S]
			dx -= @speed if Input.keys[Key.A]
			dx += @speed if Input.keys[Key.D]

			# Checking if the user goes outside boundaries
			dx = 0 if @x + dx < 0	
			dx = 0 if @x + dx > 1024 - 16
			dy = 0 if @y + dy < 0
			dy = 0 if @y + dy > 640 - 16

			# slow down diagonal moves
			if dx != 0 && dy != 0
				dx *= Math.SQRT1_2
				dy *= Math.SQRT1_2

			@x += dx
			@y += dy

			
			@spr.gotoAndStop 2 if dx < 0
			@spr.gotoAndStop 0 if dx > 0
			@spr.gotoAndStop 3 if dy < 0
			@spr.gotoAndStop 1 if dy > 0
			

		@spr.position.x = @x | 0
		@spr.position.y = @y | 0


window.Hero = Hero