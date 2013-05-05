require '../data/config.coffee'

maptxLoaded = false
maptx = new Image()
maptx.src = '/img/tilesheet.png'
maptx.onload = =>
	console.log 'Map texture loaded'
	maptxLoaded = true

class GameMap

	tw: 16
	th: 16

	w: 2048
	h: 768

	x: 0
	y: 0

	spr: new PIXI.DisplayObjectContainer
	bglayer: new PIXI.DisplayObjectContainer 
	bglayer2: new PIXI.DisplayObjectContainer
	# other players layer
	heroeslayer: new PIXI.DisplayObjectContainer
	herolayer: new PIXI.DisplayObjectContainer
	fglayer: new PIXI.DisplayObjectContainer


	constructor: (@id, @mapData) ->

		@spr.addChild @bglayer
		@spr.addChild @bglayer2
		@spr.addChild @heroeslayer
		@spr.addChild @herolayer
		@spr.addChild @fglayer

		if maptxLoaded
			@makeTilemaps()
		else
			maptx.onLoad = =>
				maptxLoaded = true
				@makeTilemaps()		

		@data = Config.Maps[@id]
		@name = @data.Name

	makeTilemaps: =>
		console.log 'Making tilemap'
		# make this async callback as it may take a while
		@makeTileMap @mapData.layers[0], (@tilemap) =>
			@bglayer.addChild @tilemap

		@makeTileMap @mapData.layers[1], (@tilemap) =>
			@bglayer2.addChild @tilemap

		@makeTileMap @mapData.layers[2], (@tilemap) =>
			@fglayer.addChild @tilemap

	makeTileMap: (data, fn) ->
		canvas = document.createElement 'canvas'
		ctx = canvas.getContext '2d'

		# don't want scaling so set canvas dimensions too
		w = canvas.width = data.width * @tw
		h = canvas.height = data.height * @th

		y = 0

		makeRow = =>
			done = false
			tilesWide = maptx.width / @tw
			tilesHigh = maptx.height / @th
			for i in [0..30]
				break if done
				for x in [0..w-1]
					val = data.data[y * data.width + x] - 1
					
					sx = (val % tilesWide) * @tw
					sy = Math.floor(val / tilesWide) * @th

					ctx.drawImage maptx, 
						sx, sy, 
						@tw, @th, 
						@tw * x, @th * y,
						@tw, @th
				y++
				if y >= data.height
					console.log 'Created tilemap'
					fn new PIXI.Sprite PIXI.Texture.fromCanvas canvas
					done = true
					break
			if !done
				setTimeout makeRow, 1

		makeRow()

	update: =>
		@spr.position.x = @x
		@spr.position.y = @y

	collide: (x, y) ->
		x < 0 or
		x > @w - 16 or
		y < 0 or
		y > @h - 16

window.GameMap = GameMap