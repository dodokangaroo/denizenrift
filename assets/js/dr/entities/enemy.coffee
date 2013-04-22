#= require ../graphics/sprite

class Enemy extends Sprite

	sw: 16
	sh: 16
	dw: 16
	dh: 16

	sx: 0
	sy: 0

	speed: 1
	distthreshold: 2

	node: null
	nodeid: 0

	x: 0
	y: 0

	constructor: (bitmap, @id, @path) ->
		super bitmap
 
		@sx = Config.GraphicOffset.Enemies[@id].x
		@sy = Config.GraphicOffset.Enemies[@id].y

		@node = @path[@nodeid]
		@x = @node[0]
		@y = @node[1]
		@nextNode()

	nextNode: ->
		@nodeid++
		@node = @path[@nodeid]

	update: =>

		return if !@node?

		tx = @node[0]
		ty = @node[1]

		distx = @x - tx
		disty = @y - ty

		dist = Math.sqrt(distx * distx + disty * disty)

		if dist < @distthreshold
			@nextNode()

		dx = 0
		dy = 0

		dx += @speed if @x < tx and Math.abs(distx) > @speed
		dx -= @speed if @x > tx and Math.abs(distx) > @speed
		dy += @speed if @y < ty and Math.abs(disty) > @speed
		dy -= @speed if @y > ty and Math.abs(disty) > @speed

		if dx != 0 && dy != 0
			dx *= Math.SQRT1_2
			dy *= Math.SQRT1_2

		@x += dx
		@y += dy

	draw: (ctx, x = @x, y = @y) ->
		super ctx, x | 0, y | 0


window.Enemy = Enemy