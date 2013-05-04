require '../data/config.coffee'

class GameMap

	w: 2048
	h: 768

	x: 0
	y: 0

	spr: null
	tilemap: null

	constructor: (@id) ->
		@spr = new PIXI.DisplayObjectContainer
		@tilemap = new PIXI.Sprite PIXI.Texture.fromImage 'img/map.png'
		@spr.addChild @tilemap

		@data = Config.Maps[@id]
		@name = @data.Name

	update: =>
		@spr.position.x = @x
		@spr.position.y = @y

	collide: (x, y) ->
		x < 0 or
		x > @w - 16 or
		y < 0 or
		y > @h - 16

window.GameMap = GameMap