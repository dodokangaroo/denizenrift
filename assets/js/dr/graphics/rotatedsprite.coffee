#= require bitmap
#= require sprite

class RotatedSprite extends Sprite

	angle: 0

	constructor: (bitmap) ->
		super bitmap

	draw: (ctx, x = @x, y = @y) ->
		if @bitmap.ready and @visible
			ctx.save()
			
			ctx.translate @x, @y
			ctx.rotate @angle
			
			ctx.drawImage @bitmap.image, @sx, @sy, @sw, @sh, @ox, @oy, @sw * @scaleX, @sh * @scaleY
			
			ctx.restore()


window.RotatedSprite = RotatedSprite