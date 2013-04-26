require '../data/config.coffee'

class Hero

	sw: 16
	sh: 16
	dw: 16
	dh: 16

	sx: 0
	sy: 0

	speed: 2

	userControlled: false

	spr: null

	constructor: (@heroclass) ->
		spr = new PIXI.Sprite PIXI.Texture.fromFrame 'Hero 0 1.png'
		@setClass @heroclass

	setClass: (heroclass) =>
		@sx = Config.GraphicOffset.Classes[heroclass].x
		@sy = Config.GraphicOffset.Classes[heroclass].y

		@basex = Config.GraphicOffset.Classes[heroclass].x

	update: =>

		if @userControlled
			dx = 0
			dy = 0

			#dy -= @speed if Input.keys[Key.W]
			#dy += @speed if Input.keys[Key.S]
			#dx -= @speed if Input.keys[Key.A]
			#dx += @speed if Input.keys[Key.D]

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

			@sx = @basex + 32 if dx < 0
			@sx = @basex + 0 if dx > 0
			@sx = @basex + 48 if dy < 0
			@sx = @basex + 16 if dy > 0

	draw: (ctx, x = @x, y = @y) ->
		super ctx, x | 0, y | 0


window.Hero = Hero