#= require_tree utils
#= require_tree graphics
#= require_tree entities
#= require_tree data

bmpentities = new Bitmap 'img/entities.png'
bmpmap = new Bitmap 'img/map.png'

class Game

	entities: []
	users: {}

	lastX: -1
	lastY: -1

	constructor: (@sio, @user, @heroclass, @userlist) ->

		@container = $('.dr')
		@canvas = $('.dr .canvas')[0]

		Input.addKeyboardListener $(document)
		Input.addMouseListener @container

		@renderer = new Renderer @canvas

		@map = new GameMap bmpmap, bmpentities, 0
		@hero = new Hero bmpentities, @heroclass

		@hero.x = 128
		@hero.y = 128
		@hero.userControlled = true

		@entities.push @map
		@entities.push @hero

		for u in @userlist
			@addUser u

		@sio.on 'mv', (u) =>
			user = @users[u.id]
			return if !user? #error user doesnt exist
			user.x = u.x
			user.y = u.y

		@sio.on 'setclass', (u) =>
			user = @users[u.id]
			return if !user? #error user doesnt exist
			user.setClass u.heroclass

		@sio.on 'userjoin', (u) =>
			@addUser u

	addUser: (u) =>
		h = new Hero bmpentities, u.heroclass
		h.x = u.x
		h.y = u.y
		@entities.push h
		@users[u.id] = h

	run: ->
		@loop()

	loop: =>
		requestAnimFrame @loop

		@renderer.clear()

		for e in @entities
			e.update()
			e.draw @renderer.ctx

		if lastX != @hero.x or lastY != @hero.y

			lastX = @hero.x
			lastY = @hero.y

			@sio.emit 'mv', @hero.x, @hero.y

window.Game = Game