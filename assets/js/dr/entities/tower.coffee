#= require ../graphics/rotatedsprite

class Tower extends RotatedSprite

	sw: 32
	sh: 32
	dw: 32
	dh: 32

	sx: 0
	sy: 0

	ox: -16
	oy: -16

	x: 0
	y: 0

	speed: 0
	dmg: 0
	range: 200

	placed: false

	constructor: (bitmap, @id, @map) ->
		super bitmap
 
		@sx = Config.GraphicOffset.Towers[@id].x
		@sy = Config.GraphicOffset.Towers[@id].y

	update: =>

		return if !@placed

		if @map.enemies.length > 0
			@target = @map.enemies[0]

		if !@target or @target.health <= 0
			return

		dx = @target.x - @x
		dy = @target.y - @y

		a = Math.atan2 dy, dx

		@angle = a + 90

	draw: (ctx, x = @x, y = @y) ->
		super ctx, x | 0, y | 0


window.Tower = Tower