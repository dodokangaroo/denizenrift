require './entities/gamemap.coffee'
require './entities/hero.coffee'
require './utils/input.coffee'

require './cmds/mv.coffee'
require './cmds/chat.coffee'
require './cmds/setjob.coffee'
require './cmds/userjoin.coffee'
require './cmds/userleft.coffee'

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
	mapData = data

class Game

	entities: []
	users: {}

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
				mapLoader.done =>
					mapLoaded = true
					console.log 'Map loaded'
					# did assets load in the meantime
					if assetsLoaded
						@init()
						@run()


	init: ->

		console.log 'Initializing'

		@loaded = true

		@map = new GameMap 0

		@stage.addChild @map.spr
		@entities.push @map

		@statWin = new PIXI.Sprite PIXI.Texture.fromFrame "Stat Window.png"
		@stage.addChild @statWin
		@statWin.position.x = 1024 - 110 - 2
		@statWin.position.y = 640 - 62 - 2

		# create our hero
		@hero = new Hero @, @job, true

		@hero.x = 128
		@hero.y = 128

		console.log @hero.x, @hero.y

		@map.spr.addChild @hero.sprContainer
	
		@entities.push @hero

		for u in @userList
			@addUser u

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
			@entities.push h
			@users[u.id] = h
			@map.spr.addChild h.sprContainer

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

		###
		# keep ui on top -------- ui is now always above map 
		lastChild = @stage.children[@stage.children.length - 1]
		if @statWin isnt lastChild
			@stage.swapChildren @statWin, lastChild
		###

		###
		# keep your hero above others
		lastChild = @map.spr.children[@map.spr.children.length - 1]
		if @hero.sprContainer isnt lastChild
			@map.spr.swapChildren @hero.sprContainer, lastChild
		###

		@map.x = -Math.min(Math.max(0, @hero.x - @halfw), @map.w - @w)
		@map.y = -Math.min(Math.max(0, @hero.y - @halfh), @map.h - @h)

		# let pixijs render
		@renderer.render @stage

		stats.end()

	doMovement: ->
		if lastX != @hero.x or lastY != @hero.y

			lastX = @hero.x
			lastY = @hero.y

			@sio.emit 'mv', @hero.x, @hero.y

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

		Input.update()

	printChat: (msg) ->
		out = $('.chatout') 
		out.append  msg
		out.animate scrollTop: out[0].scrollHeight, 200

window.Game = Game