require '../data/config.coffee'
require '../utils/input.coffee'

class Hero

	speed: 2

	userControlled: false

	spr: null

	constructor: (@game, @heroclass) ->
		@setClass @heroclass

	setClass: (@heroclass) =>
		@sx = Config.GraphicOffset.Classes[heroclass].x
		@sy = Config.GraphicOffset.Classes[heroclass].y

		@basex = Config.GraphicOffset.Classes[heroclass].x

		@game.stage.removeChild @spr if @spr?

		@spr = new PIXI.MovieClip [PIXI.Texture.fromFrame "Hero #{@heroclass} 0.png"]
		@game.stage.addChild @spr

	update: =>

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