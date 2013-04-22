#= require ../graphics/sprite

class GameMap extends Sprite

	sw: 1024
	sh: 640
	dw: 1024
	dh: 640

	sx: 0
	sy: 0

	constructor: (bitmap, @bmpentities, @id) ->
		super bitmap

		@data = Config.Maps[@id]
		@name = @data.Name

	update: =>

window.GameMap = GameMap