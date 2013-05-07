class FireBall

	spr: null

	spd: 3

	x: 0
	y: 0

	dx: 0
	dy: 0

	constructor: (@game, @x, @y, @a) ->

		@dx = Math.cos @a 
		@dy = Math.sin @a

		@spr = new PIXI.MovieClip [
			PIXI.Texture.fromFrame "Fire 0.png"
			PIXI.Texture.fromFrame "Fire 1.png"
			PIXI.Texture.fromFrame "Fire 2.png"
			PIXI.Texture.fromFrame "Fire 3.png"
			PIXI.Texture.fromFrame "Fire 4.png"
			PIXI.Texture.fromFrame "Fire 5.png"
			PIXI.Texture.fromFrame "Fire 6.png"
			PIXI.Texture.fromFrame "Fire 7.png"
		]

		frame = (@a + Math.PI + Math.PI / 2) / Math.PI / 2

		# get appropriate frame
		@spr.gotoAndStop Math.round(frame * 8) % 8

	update: =>

		@x += @dx * @spd
		@y += @dy * @spd

		@spr.position.x = @x
		@spr.position.y = @y

		if @game.map.collide @x, @y
			@game.removeEntity @
			@game.map.heroeslayer.removeChild @spr

window.FireBall = FireBall