#= require bitmap

class Sprite

	sx: 0 # Source x position
	sy: 0 # Source y position
	sw: 0 # Source width
	sh: 0 # Source height
	ox: 0 # Destination x position
	oy: 0 # Destination y position
	x:  0 # Position x in the world
	y:  0 # Position y in the world
	scaleX: 1
	scaleY: 1
	visible: true

	constructor: (@bitmap) ->


	draw: (ctx, x = @x, y = @y) ->
		if @bitmap.ready and @visible
			ctx.drawImage @bitmap.image, @sx, @sy, @sw, @sh, x + @ox, y + @oy, @sw * @scaleX, @sh * @scaleY


window.Sprite = Sprite