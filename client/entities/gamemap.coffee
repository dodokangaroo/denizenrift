require '../data/config.coffee'

class GameMap

	w: 1024
	h: 640

	spr: null

	constructor: (@id) ->
		@spr = new PIXI.Sprite PIXI.Texture.fromImage 'img/map.png'

		@data = Config.Maps[@id]
		@name = @data.Name

	update: =>

	collide: (x, y) ->
		x < 0 or
		x > 1008 or
		y < 0 or
		y > 624 or
		(x > 896 and y > 560) # ui

window.GameMap = GameMap