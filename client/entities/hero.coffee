require '../data/config.coffee'
require '../utils/input.coffee'

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

	constructor: (@game, @heroclass, @userControlled = false) ->
		
		@sprContainer = new PIXI.DisplayObjectContainer

		# allow hover on other players
		@allowHover() if !@userControlled

		@setClass @heroclass

	setClass: (@heroclass) =>

		# remove old graphic
		@sprContainer.removeChild @spr if @spr?

		#get new graphic
		@spr = new PIXI.MovieClip [
			PIXI.Texture.fromFrame "Hero #{@heroclass} 0.png"
			PIXI.Texture.fromFrame "Hero #{@heroclass} 1.png"
			PIXI.Texture.fromFrame "Hero #{@heroclass} 2.png"
			PIXI.Texture.fromFrame "Hero #{@heroclass} 3.png"
		]

		# add graphic
		@sprContainer.addChild @spr

	update: =>

		# if player controlled and chatin is not selected
		if @userControlled && Input.hasFocus()
			dx = 0
			dy = 0

			dy -= @speed if Input.keys[Key.W]
			dy += @speed if Input.keys[Key.S]
			dx -= @speed if Input.keys[Key.A]
			dx += @speed if Input.keys[Key.D]

			# Checking if the user goes outside boundaries
			dx = 0 if @x + dx < 0	
			dx = 0 if @x + dx > 1024 - 16
			dy = 0 if @y + dy < 0
			dy = 0 if @y + dy > 640 - 16

			# slow down diagonal moves
			if dx != 0 && dy != 0
				dx *= Math.SQRT1_2
				dy *= Math.SQRT1_2

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
		@sprContainer.hitArea = new PIXI.Rectangle 0, 0, 16, 16

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