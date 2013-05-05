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

	mapW: 0
	mapH: 0

	spr: new PIXI.DisplayObjectContainer
	bglayer: new PIXI.DisplayObjectContainer 
	bglayer2: new PIXI.DisplayObjectContainer
	# other players layer
	heroeslayer: new PIXI.DisplayObjectContainer
	herolayer: new PIXI.DisplayObjectContainer
	fglayer: new PIXI.DisplayObjectContainer

	collisionMap: null

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
		@makeTileMap @mapData.layers[0], (tm) =>
			@bglayer.addChild tm

		@makeTileMap @mapData.layers[1], (tm) =>
			@bglayer2.addChild tm

		@makeTileMap @mapData.layers[2], (tm) =>
			@fglayer.addChild tm

		@makeCollisionMap @mapData.layers[3]

		# debug visualising collison map

		###
		@makeTileMap @mapData.layers[3], (tm) =>
			@fglayer.addChild tm
		###


	makeTileMap: (data, fn) ->
		canvas = document.createElement 'canvas'
		ctx = canvas.getContext '2d'

		# don't want scaling so set canvas dimensions too
		w = canvas.width = data.width * @tw
		h = canvas.height = data.height * @th
		tilesWide = maptx.width / @tw
		tilesHigh = maptx.height / @th

		y = 0

		makeRow = =>
			done = false
			
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

	makeCollisionMap: (data) ->
		w = data.width
		h = data.height

		@mapW = w
		@mapH = h

		# create map
		@collisionMap = []
		for y in [0..h-1]
			# add new row
			@collisionMap[y] = []
			for x in [0..w-1]
				val = data.data[y * w + x]
				# 0 is an empty tile, else solid
				@collisionMap[y][x] = val

		#console.log JSON.stringify @collisionMap


	update: =>
		@spr.position.x = @x
		@spr.position.y = @y

	collide: (x, y) ->

		# check tilemap collision
		return true if @collideTilemap x, y

		# return map bounds check
		x < 0 or
		x > @w - 16 or
		y < 0 or
		y > @h - 16

	collideTilemap: (x, y) ->
		return false if !@collisionMap?

		tx = Math.floor(x / @tw)
		ty = Math.floor(y / @th)

		return false if ty < 0 or tx < 0 or tx >= @mapW or ty >= @mapH

		# check each side of char
		return @collisionMap[ty][tx]


window.GameMap = GameMap