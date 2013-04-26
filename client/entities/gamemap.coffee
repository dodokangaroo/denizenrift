require '../data/config.coffee'

class GameMap

	sw: 1024
	sh: 640
	dw: 1024
	dh: 640

	sx: 0
	sy: 0

	spr: new PIXI.Sprite PIXI.Texture.fromImage 'img/map.png'

	constructor: (@id) ->
		@data = Config.Maps[@id]
		@name = @data.Name

	update: =>

window.GameMap = GameMap