require './entities/gamemap.coffee'
require './entities/hero.coffee'
require './utils/input.coffee'

require './cmds/mv.coffee'
require './cmds/chat.coffee'
require './cmds/setclass.coffee'
require './cmds/userjoin.coffee'
require './cmds/userleft.coffee'

stats = new Stats()
stats.setMode 0

stats.domElement.style.position = 'absolute'
stats.domElement.style.left = '0px'
stats.domElement.style.top = '0px'


class Game

	entities: []
	users: {}
	spriteSheets: ['sprites/entities.json']

	lastX: -1
	lastY: -1

	constructor: (@sio, @user, @heroclass, @userlist) ->

		canvas = $('.dr .canvas')

		# show chat
		$('.chatbox').removeClass 'invisible'

		@stage = new PIXI.Stage
		@renderer = PIXI.autoDetectRenderer 1024, 640
			
		canvas.append @renderer.view
		canvas.append stats.domElement

		Input.addKeyboardListener $(document)
		Input.addMouseListener canvas

		@setupCmds()

		loader = new PIXI.AssetLoader @spriteSheets
		loader.onComplete = =>
			@init()
			@run()
		loader.load()

	init: ->

		@map = new GameMap 0

		@stage.addChild @map.spr
		@entities.push @map

		@hero = new Hero @, @heroclass

		@hero.x = 128
		@hero.y = 128
		@hero.userControlled = true
	
		@entities.push @hero

		for u in @userlist
			@addUser u

	setupCmds: ->
		new CmdMv @user, @, @sio
		new CmdChat @user, @, @sio
		new CmdSetClass @user, @, @sio
		new CmdUserJoin @user, @, @sio
		new CmdUserLeft @user, @, @sio

	addUser: (u) =>
		h = new Hero @, u.heroclass
		h.x = u.x
		h.y = u.y
		h.data = u
		@entities.push h
		@users[u.id] = h

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