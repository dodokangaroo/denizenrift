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

		requestAnimFrame @loop

		for e in @entities
			e.update()

		if lastX != @hero.x or lastY != @hero.y

			lastX = @hero.x
			lastY = @hero.y

			@sio.emit 'mv', @hero.x, @hero.y

		@renderer.render @stage

		stats.end()

		if Input.keysPressed[Key.ENTER]
			txt = $('.chatin').val()		  		#  get the text
			$('.chatin').val '' 					# clear the txt in
			$('.chatout').append "<li>Me: #{txt}</li>" 	# output the text
			@sio.emit 'chat', txt

		Input.update()

window.Game = Game