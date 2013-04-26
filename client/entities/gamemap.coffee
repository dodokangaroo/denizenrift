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

window.GameMap = GameMap