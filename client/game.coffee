require './entities/gamemap.coffee'
require './entities/hero.coffee'
require './entities/fireball.coffee'
require './entities/camera.coffee'
require './utils/input.coffee'

stats = new Stats()
stats.setMode 0

stats.domElement.style.position = 'absolute'
stats.domElement.style.left = '0px'
stats.domElement.style.top = '0px'

# start loading straight away

spriteSheets = [
	'/sprites/entities.json'
	'/sprites/objects.json'
	'/sprites/ui.json'
]

mapData = null

mapLoaded = false
assetsLoaded = false

mapLoader = null
assetLoader = null

assetLoader = new PIXI.AssetLoader spriteSheets
assetLoader.onComplete = =>
	console.log 'Assets loaded'
	assetsLoaded = true
assetLoader.load()

mapLoader = $.get '/maps/map1.json', (data) ->
	console.log 'Map loaded'
	mapLoaded = true
	mapData = data

class Game

	entities: []
	addEntities: []
	removeEntities: []

	users: {}

	# our player
	hero: null

	lastX: -1
	lastY: -1

	w: 1024
	h: 640
	halfw: 512
	halfh: 320

	# stat ui window
	statWin: null

	# are all the assets loaded
	loaded: false

	# Camera for offset
	camera: null

	constructor: (@sio, @user, @job, @userList) ->

		console.log 'New game'

		canvas = $('.dr .canvas')

		# show chat
		$('.chatbox').removeClass 'invisible'

		# create an interactive pixi stage
		@stage = new PIXI.Stage 0x202020, true
		@renderer = PIXI.autoDetectRenderer 1024, 640
		
		canvas.append @renderer.view
		canvas.append stats.domElement

		Input.addKeyboardListener $(document)
		Input.addMouseListener canvas

		@setupCmds()

		# did we load before game started
		if assetsLoaded and mapLoaded
			@init()
			@run()
		else # wait for load
			if !assetsLoaded
				# wait for assets to load
				assetLoader.onComplete = =>
					assetsLoaded = true
					console.log 'Assets loaded'
					# did maps loaded in the meantime
					if mapLoaded
						@init()
						@run()
			if !mapLoaded
				# wait for maps to load
				mapLoader.done (data) =>
					mapData = data
					mapLoaded = true
					console.log 'Map loaded'
					# did assets load in the meantime
					if assetsLoaded
						@init()
						@run()

	addEntity: (e) ->
		@addEntities.push e

	removeEntity: (e) ->
		@removeEntities.push e

	init: ->

		console.log 'Initializing'

		@loaded = true

		@map = new GameMap 0, mapData

		@stage.addChild @map.spr
		@addEntity @map

		@statWin = new PIXI.Sprite PIXI.Texture.fromFrame "Stat Window.png"
		@stage.addChild @statWin
		@statWin.position.x = 1024 - 110 - 2
		@statWin.position.y = 640 - 62 - 2

		# create our hero
		@hero = new Hero @, @job, true

		@hero.x = 128
		@hero.y = 128

		@map.herolayer.addChild @hero.sprContainer
	
		@addEntity @hero

		for u in @userList
			@addUser u

		# create the camera which will contain the offset
		@camera = new Camera @map.w, @map.h, @w, @h

	setupCmds: ->
		new CmdMv @user, @, @sio
		new CmdChat @user, @, @sio
		new CmdSetJob @user, @, @sio
		new CmdUserJoin @user, @, @sio
		new CmdUserLeft @user, @, @sio

	addUser: (u) =>

		@userList.push u

		if @loaded

			h = new Hero @, u.job
			h.x = u.x
			h.y = u.y
			h.data = u
			@addEntity h
			@users[u.id] = h
			@map.heroeslayer.addChild h.sprContainer

	run: ->
		@loop()

	loop: =>
		stats.begin()

		# ask for loop to be run again asap (max 60fps)
		requestAnimFrame @loop

		for e in @entities
			e.update()

		@doMovement()
		@doChat()
		@doAttack()

		@map.x = -Math.min(Math.max(0, @hero.x - @halfw), @map.w - @w)
		@map.y = -Math.min(Math.max(0, @hero.y - @halfh), @map.h - @h)
		@camera.update @hero.x, @hero.y

		# let pixijs render
		@renderer.render @stage

		Input.update()

		# add entitis at end of frame
		for e in @addEntities
			@entities.push e
		@addEntities.length = 0

		# remove entities at end of frame
		for e in @removeEntities
			i = @entities.indexOf e
			@entities.splice i, 1 if i > 0
		@removeEntities.length = 0

		stats.end()

	doMovement: ->
		if lastX != @hero.x or lastY != @hero.y

			lastX = @hero.x
			lastY = @hero.y

			@sio.emit 'mv', @hero.x, @hero.y, @hero.dx, @hero.dy

	doChat: ->
		# if user press enter 
		if Input.keysPressed[Key.ENTER]
			txt = $('.chatin').val()
			# if there is text and the chat was selected, send the message
			if txt.length > 0 && $('.chatin').is(':focus')
				$('.chatin').val '' 								
				@printChat "<div>#{@user.name}: #{txt}</div>" 	
				@sio.emit 'chat', txt
				$('.chatin').blur()
			# else select the chat
			else
				$('.chatin').focus()
		# if the user press ESC while the chat box is focused, remove focus from it
		else if Input.keysPressed[Key.ESCAPE] && $('.chatin').is(':focus')
			$('.chatin').blur()

	doAttack: ->

		if Input.hasFocus()
			if Input.keysReleased[Key.DIGIT_1]

				# -8 for the player width \ height
				dx = Input.mouseX - @hero.x - 8 + @camera.offSetX
				dy = Input.mouseY - @hero.y - 8 + @camera.offSetY
				a = Math.atan2(dy, dx)

				fb = new FireBall @, @hero.x, @hero.y, a

				@addEntity fb
				@map.heroeslayer.addChild fb.spr
			else if Input.keysReleased[Key.DIGIT_2]

				for i in [0..16]

					fb = new FireBall @, @hero.x, @hero.y, i * (Math.PI / 8)

					@addEntity fb
					@map.heroeslayer.addChild fb.spr
			else if Input.keysReleased[Key.DIGIT_3]

				x = Input.mouseX + @camera.offSetX
				y = Input.mouseY + @camera.offSetY
				a = 0
				n = 256

				makeFire = =>
					fb = new FireBall @, x, y, a
					a += (Math.PI / 16)

					@addEntity fb
					@map.heroeslayer.addChild fb.spr

					if n-- > 0
						setTimeout makeFire, 10
				makeFire()

	printChat: (msg) ->
		out = $('.chatout') 
		out.append  msg
		out.animate scrollTop: out[0].scrollHeight, 200

window.Game = Game