#= require ../graphics/sprite

class Hero extends Sprite

	sw: 16
	sh: 16
	dw: 16
	dh: 16

	sx: 0
	sy: 0

	speed: 2

	userControlled: false

	constructor: (bitmap, @heroclass) ->
		super bitmap
		@setClass @heroclass

	setClass: (heroclass) =>
		@sx = Config.GraphicOffset.Classes[heroclass].x
		@sy = Config.GraphicOffset.Classes[heroclass].y

		@basex = Config.GraphicOffset.Classes[heroclass].x

	update: =>

		if @userControlled
			dx = 0
			dy = 0

			dy -= @speed if Input.keys[Key.W]
			dy += @speed if Input.keys[Key.S]
			dx -= @speed if Input.keys[Key.A]
			dx += @speed if Input.keys[Key.D]

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