require '../data/config.coffee'
require '../utils/input.coffee'
require './statbar.coffee'

class Hero

	speed: 2

	# is this the local user
	userControlled: false

	# sprite
	spr: null

	# sprite container
	sprContainer: null

	# player info
	data: null

	# hovering img
	#hoverSpr: null

	# health bar
	healthbar: null

	# mana bar
	manabar: null

	x: 0
	y: 0

	dx: 0
	dy: 0

	constructor: (@game, @job, @userControlled = false) ->
		
		@sprContainer = new PIXI.DisplayObjectContainer

		# allow hover on other players
		@allowHover() if !@userControlled

		@setJob @job

		@healthbar = new StatBar (@userControlled ? 1 : 0)
		@sprContainer.addChild @healthbar.spr
		@healthbar.spr.position.x = -2
		@healthbar.spr.position.y = -9

		@healthbar.fill.scale.x = Math.random()

		manabar = new StatBar 2
		@sprContainer.addChild manabar.spr
		manabar.spr.position.x = -2
		manabar.spr.position.y = -6

		manabar.fill.scale.x = Math.random()


	setJob: (@job) =>

		# remove old graphic
		@sprContainer.removeChild @spr if @spr?

		#get new graphic
		@spr = new PIXI.MovieClip [
			PIXI.Texture.fromFrame "Hero #{@job} 0.png"
			PIXI.Texture.fromFrame "Hero #{@job} 1.png"
			PIXI.Texture.fromFrame "Hero #{@job} 2.png"
			PIXI.Texture.fromFrame "Hero #{@job} 3.png"
		]

		# add graphic
		@sprContainer.addChild @spr

	update: =>

		# if player controlled and chatin is not selected
		if @userControlled && Input.hasFocus()
			dx = @dx = 0
			dy = @dy = 0

			dy -= @speed if Input.keys[Key.W]
			dy += @speed if Input.keys[Key.S]
			dx -= @speed if Input.keys[Key.A]
			dx += @speed if Input.keys[Key.D]

			if Input.keys[Key.SHIFT]
				dx *= 5
				dy *= 5

			# Checking if the user goes outside boundaries

			dx = 0 if @game.map.collide @x + dx, @y 
			dy = 0 if @game.map.collide @x, @y + dy

			# also check bottom right corner of char

			dx = 0 if @game.map.collide @x + 16 + dx, @y + 16
			dy = 0 if @game.map.collide @x + 16, @y + 16 + dy


			# slow down diagonal moves
			if dx != 0 && dy != 0
				dx *= Math.SQRT1_2
				dy *= Math.SQRT1_2

			@dx = dx
			@dy = dy
			
		@x += dx
		@y += dy

		@spr.gotoAndStop 2 if dx < 0
		@spr.gotoAndStop 0 if dx > 0
		@spr.gotoAndStop 3 if dy < 0
		@spr.gotoAndStop 1 if dy > 0

		@sprContainer.position.x = @x | 0
		@sprContainer.position.y = @y | 0

	allowHover: ->
		###
		@hoverSpr = new PIXI.MovieClip [
			PIXI.Texture.fromFrame "Hover 0.png"
			PIXI.Texture.fromFrame "Hover 1.png"
		]

		@sprContainer.addChild @hoverSpr
		@hoverSpr.visible = false

		@hoverSpr.position.y = 8
		###

		@sprContainer.setInteractive true
		@sprContainer.mouseover = @onMouseOver
		@sprContainer.mouseout = @onMouseOut
		@sprContainer.hitArea = new PIXI.Rectangle -8, -8, 32, 32

		#@hoverSpr.animationSpeed = 0.05

	onMouseOver: =>
		###
		@hoverSpr.visible = true
		@hoverSpr.play()
		###

		$('.dr').addClass 'cursorkill'

	onMouseOut: =>
		###
		@hoverSpr.visible = false
		@hoverSpr.stop()
		###

		$('.dr').removeClass 'cursorkill'


window.Hero = Hero