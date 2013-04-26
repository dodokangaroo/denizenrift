require './entities/gamemap.coffee'
require './entities/hero.coffee'
require './utils/input.coffee'

require './cmds/mv.coffee'
require './cmds/setclass.coffee'
require './cmds/userjoin.coffee'
require './cmds/userleft.coffee'

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

		@setupCmds()

		loader = new PIXI.AssetLoader @spriteSheets
		loader.onComplete = =>
			@init()
			@run()
		loader.load()

	init: ->

		@map = new GameMap 0
		@hero = new Hero @heroclass

		@stage.addChild @map.spr
		@stage.addChild @hero.spr

		@hero.x = 128
		@hero.y = 128
		@hero.userControlled = true

		@entities.push @map
		@entities.push @hero

		for u in @userlist
			@addUser u

	setupCmds: ->
		new CmdMv @user, @, @sio
		new CmdSetClass @user, @, @sio
		new CmdUserJoin @user, @, @sio
		new CmdUserLeft @user, @, @sio

	addUser: (u) =>
		h = new Hero txEntity, u.heroclass
		h.x = u.x
		h.y = u.y
		@entities.push h
		@users[u.id] = h
		@stage.addChild @h.spr

	run: ->
		@loop()

	loop: =>
		requestAnimFrame @loop

		for e in @entities
			e.update()

		if lastX != @hero.x or lastY != @hero.y

			lastX = @hero.x
			lastY = @hero.y

			@sio.emit 'mv', @hero.x, @hero.y

		@renderer.render @stage

window.Game = Game